#!/bin/bash

# Ensure we are running under bash
if [ "$BASH_SOURCE" = "" ]; then
    /bin/bash "$0"
    exit 0
fi

#
# Load bash-menu script
#
# NOTE: Ensure this is done before using
#       or overriding menu functions/variables.
#
. "bash-menu.sh"


################################
## Example Menu Actions
##
## They should return 1 to indicate that the menu
## should continue, or return 0 to signify the menu
## should exit.
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
    echo "Action C"

    echo -n "Press enter to continue ... "
    read response

    return 1
}

actionX() {
    return 0
}


################################
## Setup Example Menu
################################

## Menu Item Text
##
## It makes sense to have "Exit" as the last item,
## as pressing Esc will jump to last item (and
## pressing Esc while on last item will perform the
## associated action).
##
## NOTE: If these are not all the same width
##       the menu highlight will look wonky
menuItems=(
    "1. Item 1"
    "2. Item 2"
    "3. Item 3"
    "A. Item A"
    "B. Item B"
    "Q. Exit  "
)

## Menu Item Actions
menuActions=(
    actionA
    actionB
    actionC
    actionA
    actionB
    actionX
)

## Override some menu defaults
menuTitle=" Demo of bash-menu"
menuFooter=" Enter=Select, Navigate via Up/Down/First number/letter"
menuWidth=60
menuLeft=25
menuHighlight=$DRAW_COL_YELLOW


################################
## Run Menu
################################
menuInit
menuLoop


exit 0
