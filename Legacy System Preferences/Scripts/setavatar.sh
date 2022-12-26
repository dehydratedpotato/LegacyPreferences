#!/bin/sh

#  setavatar.sh
#  Legacy System Preferences
#
#  Created by BitesPotatoBacks on 12/24/22.
#

user="$1"
image="$2"

if [[ "$image" != *.png ]]; then
    cp "$image" /tmp/avatar.png
    image="/tmp/avatar.png"
fi

dscl . delete /Users/$user JPEGPhoto
dscl . delete /Users/$user Picture
tmp="$(mktemp)"
printf "0x0A 0x5C 0x3A 0x2C dsRecTypeStandard:Users 2 dsAttrTypeStandard:RecordName externalbinary:dsAttrTypeStandard:JPEGPhoto\n%s:%s" "$user" "$image" > "$tmp"
dsimport "$tmp" /Local/Default M
rm "$tmp"
rm "$image"
