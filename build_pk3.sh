#!/bin/bash

EXCLUDES=(
    "*.sh"
    "*.pk3"
    "*.py"
    ".git/**"
)

if [ $# -eq 0 ]
    then
        zip -r doomablo_$(git describe --exact-match --tags 2> /dev/null || git rev-parse --short HEAD)_$(date '+%d-%m-%Y_%H').pk3 * -x "${EXCLUDES[@]}"
    else
        zip -r doomablo_$1.pk3 * -x "${EXCLUDES[@]}"
fi