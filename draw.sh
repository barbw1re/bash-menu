#!/bin/bash

#
# Public Functions:
#
#   drawClear()
#   drawColour(colour = DRAW_COL_DEF, bgColour = DRAW_COL_DEF)
#
#   drawPlain(text, newLine = 0)
#   drawHighlight(text, newLine = 0)
#   drawPlainAt(left, top, text, newLine = 0)
#   drawHighlightAt(left, top, text, newLine = 0)
#
# Colours
#
#   DRAW_COL_DEF
#   DRAW_COL_BLACK
#   DRAW_COL_WHITE
#   DRAW_COL_RED
#   DRAW_COL_GREEN
#   DRAW_COL_YELLOW
#   DRAW_COL_BLUE
#   DRAW_COL_GRAY
#

DRAW_COL_DEF=39
DRAW_COL_BLACK=30
DRAW_COL_WHITE=97
DRAW_COL_RED=31
DRAW_COL_GREEN=32
DRAW_COL_YELLOW=33
DRAW_COL_BLUE=34
DRAW_COL_GRAY=37

# drawClear()
drawClear() {
    $ESC_WRITE "\033c"
}

# drawColour(colour = DRAW_COL_DEF, bgColour = DRAW_COL_DEF)
drawColour() {
    local colour=$DRAW_COL_DEF
    local bgColour=$((DRAW_COL_DEF+10))

    if [[ ! -z "$1" && "$1" != "" ]]; then
        colour="$1"
    fi

    if [[ ! -z "$2" && "$2" != "" ]]; then
        bgColour="$2"
    fi

    $ESC_ECHO "\033c\033[H\033[J\033[${colour};${bgColour}m\033[J"
}

# drawPlain(text, newLine = 0)
drawPlain() {
    draw_SetDrawMode
    if [[ -z "$2" || "$2" -eq 0 ]]; then
        $ESC_WRITE "$1"
    else
        $ESC_ECHO "$1"
    fi
    draw_SetWriteMode
}

# drawHighlight(text, newLine = 0)
drawHighlight() {
    draw_StartHighlight
    if [[ -z "$2" || "$2" -eq 0 ]]; then
        drawPlain "$1" 0
    else
        drawPlain "$1" 1
    fi
    draw_EndHighlight
}

# drawPlainAt(left, top, text, newLine = 0)
drawPlainAt() {
    draw_MoveTo $1 $2
    if [[ -z "$4" || "$4" -eq 0 ]]; then
        $ESC_WRITE "$3"
    else
        $ESC_ECHO "$3"
    fi
}

# drawHighlightAt(left, top, text, newLine = 0)
drawHighlightAt() {
    draw_StartHighlight
    if [[ -z "$4" || "$4" -eq 0 ]]; then
        drawPlainAt "$1" "$2" "$3" 0
    else
        drawPlainAt "$1" "$2" "$3" 1
    fi
    draw_EndHighlight
}


ESC_WRITE='echo -en'
ESC_ECHO='echo -e'

draw_MoveTo() {
    $ESC_WRITE "\033[${1};${2}H"
}

draw_StartHighlight() {
    $ESC_WRITE "\033[7m"
}

draw_EndHighlight() {
    $ESC_WRITE "\033[27m"
}

draw_SetDrawMode() {
    $ESC_WRITE "\033%@\033(0"
}

draw_SetWriteMode() {
    $ESC_WRITE "\033(B"
}
