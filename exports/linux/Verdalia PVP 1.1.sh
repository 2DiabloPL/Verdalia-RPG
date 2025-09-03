#!/bin/sh
echo -ne '\033c\033]0;prototyp player\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Verdalia PVP 1.1.x86_64" "$@"
