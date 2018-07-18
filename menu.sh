#!/bin/bash

# Ensure we are running under bash
shell=`echo $$ | xargs -i readlink -f /proc/\{\}/exe`
if [ "$(basename $shell)" != "bash" ]; then
    /bin/bash "$0"
    exit 0
fi

dir=`pwd`
cd $(dirname "$0")
root=`pwd`
cd "$dir"

if [ ! -s "$root/draw.sh" ]; then
    echo "ERROR: Missing required draw.sh script"
    exit 1
fi

# Load terminal drawing functions
. "$root/draw.sh"


################################
## Example Menu Actions
##
## They should return to the menu an indicator
## as to whether the menu should continue or not.
################################
actionA() {
    echo "Action A"

    echo -n "Press enter to continue ... "
    read response

    return 1
}

actionB() {
    echo "Action B"

    echo -n "Press enter to continue ... "
    read response

    return 1
}

actionC() {
    # Exit Action - return 0
    return 0
}


################################
## Setup Menu
##
## TODO: Stop requiring user to set item text
##       to same width - adjust automatically.
################################

# Top of menu (row 2)
menuTop=2

# Left offset for menu items (not border)
menuLeft=15

# Left offset for menu border (not menu items)
menuMargin=4

declare -a menuItems
declare -a menuActions

menuItems[0]="1. Item 1"
menuActions[0]=actionA

menuItems[1]="2. Item 2"
menuActions[1]=actionB

menuItems[2]="3. Exit  "
menuActions[2]=actionC

menuItemCount=${#menuItems[@]}
menuLastItem=$((menuItemCount-1))


################################
## Show Menu
################################
showMenu() {
    local menuSize=$((menuItemCount+2))
    local menuEnd=$((menuSize+menuTop+1))

    drawClear
    drawColour $DRAW_COL_WHITE $DRAW_COL_GREEN

    # Menu header
    drawHighlightAt $menuTop $menuMargin " Super Bash Menu System                   " 1

    # Menu (side) borders
    local marginSpaces=$((menuMargin-1))
    local leftGap=`printf "%${marginSpaces}s" ""`
    for row in $(seq 1 $menuSize); do
        drawPlain "${leftGap}x                                        x" 1
    done

    # Menu footer
    drawHighlightAt $menuEnd $menuMargin " Enter=Select, Up/Down=Prev/Next Option   " 1

    # Menu items
    for item in $(seq 0 $menuLastItem); do
        clearMenuItem $item
    done
}

clearMenuItem() {
    local item=$1
    local top=$((menuTop+item+2))
    local menuText=${menuItems[$item]}

    drawPlainAt $top $menuLeft "$menuText"
}

markMenuItem() {
    local item=$1
    local top=$((menuTop+item+2))
    local menuText=${menuItems[$item]}

    drawHighlightAt $top $menuLeft "$menuText"
}

checkMenu() {
    local choice=$1

    local after=$((choice+1))
    [[ $after -gt $menuLastItem ]] && after=0

    local before=$((choice-1))
    [[ $before -lt 0 ]] && before=$menuLastItem

    # Clear highlight from prev/next menu items
    clearMenuItem $before
    clearMenuItem $after

    # Highlight current menu item
    markMenuItem $choice

    # Get keyboard input
    local key=""
    local extra=""

    read -s -n1 key 2> /dev/null >&2
    while read -s -n1 -t .05 extra 2> /dev/null >&2 ; do
        key="$key$extra"
    done

    # Handle known keys
    local escKey=`echo -en "\033"`
    local upKey=`echo -en "\033[A"`
    local downKey=`echo -en "\033[B"`

    if [[ $key = $upKey ]]; then
        return $before
    elif [[ $key = $downKey ]]; then
        return $after
    elif [[ $key = $escKey ]]; then
        if [[ $choice -eq $menuLastItem ]]; then
            # Pressing Esc while on last menu item will trigger action
            # This is a helper as we assume the last menu option is exit
            key=""
        else
            return $menuLastItem
        fi
    fi

    if [[ "$key" = "" ]]; then
        # Notify that Enter key was pressed
        return 255
    fi

    return $choice
}


################################
## Cleanup
################################
cleanup() {
    drawClear
    exit 0
}


################################
## Main Menu Loop
################################
trap "cleanup" SIGTERM SIGINT

choice=0
running=1

showMenu

while [[ $running -eq 1 ]]; do
    checkMenu $choice
    newChoice=$?

    if [[ $newChoice -eq 255 ]]; then
        # Enter pressed - run menu action
        drawClear
        action=${menuActions[$choice]}
        $action
        running=$?
        [[ $running -eq 1 ]] && showMenu
    elif [[ $newChoice -lt $menuItemCount ]]; then
        # Update selected menu item
        choice=$newChoice
    else
        # Invalid menu item selected (somehow)
        echo "Choice $newChoice is invalid"
    fi
done

cleanup
