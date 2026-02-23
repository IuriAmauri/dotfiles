#!/bin/bash

BAR_TEXT=$(date +"󰃭")

HEADER=$(date +"%A, %d %B %Y")

TODAY=$(date +%e | tr -d ' ')

PREV=$(cal -m $(date -d "last month" +%m) $(date -d "last month" +%Y) | sed 's/^/  /')

CURR=$(cal | sed 's/^/  /' | sed "s/\b$TODAY\b/<u><span color='#ff79c6'>$TODAY<\/span><\/u>/")

NEXT=$(cal -m $(date -d "next month" +%m) $(date -d "next month" +%Y) | sed 's/^/  /')

FULL_TOOLTIP="<b>$HEADER</b>

<span size='smaller' alpha='50%'>$PREV</span>
$CURR
<span size='smaller' alpha='50%'>$NEXT</span>"

jq -nc --arg text "$BAR_TEXT" --arg tooltip "<tt>$FULL_TOOLTIP</tt>" \
    '{"text": $text, "tooltip": $tooltip}'
