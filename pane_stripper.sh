#!/bin/bash

FILES=$(find . -name "*.prefPane" -print)

for LINE in $FILES
do
    codesign --remove-signature "$LINE"
    sudo spctl --add "$LINE"
    sudo chown root:wheel "$LINE"
done