#!/bin/bash
# generates make/README.md
MYPWD="$(dirname $(realpath $0))"

PKGS=$(
for dir in avm $(find "$MYPWD" -maxdepth 1 -mindepth 1 -type d); do
pkg="${dir##*/}"
echo "$pkg" | grep -qE "^(busybox|libs|linux)$" && continue
cat="$(sed -n 's/^$(PKG)_CATEGORY *:= *//p' $dir/$pkg.mk 2>/dev/null)"
echo "${cat:-000Packages}##$pkg"
done | sort )

echo '[//]: # ( Do not edit this file! Run generate.sh to create it. )' > "$MYPWD/README.md"
echo "$PKGS" | sed 's/##.*//g' | uniq | while read cat; do
echo -e "\n### ${cat//0}"
echo "$PKGS" | sed -n "s/^${cat}##//p" | while read pkg; do

dsc="$(sed -rn 's/[ \t]*bool "([^\"]*)"[ \t]*.*/\1/p' "$MYPWD/$pkg/Config.in" 2>/dev/null | head -n1)"
[ "$pkg" == "mod" ] && dsc="Freetz(-MOD)"
[ "$pkg" == "avm" ] && dsc="AVM Services"
[ -z "$dsc" ] && echo "ignored: $pkg" 1>&2 && continue
[ "${dsc// /-}" != "$(echo "${dsc// /-}" | sed "s/^$pkg//I")" ] && itm="$dsc" || itm="$pkg: $dsc"

[ -e "$MYPWD/../docs/wiki/packages/${pkg%-cgi}.html" -o "$pkg" == "avm" ] && lnk="https://freetz-ng.github.io/freetz-ng/wiki/packages/${pkg%-cgi}" || lnk=""
[ -e "$MYPWD/$pkg/README.md" ] && lnk="$pkg/README.md"
[ -n "$lnk" ] && itm="[$itm]($lnk)" || itm="<u>$itm</u>"

echo -e "\n  * **$itm<a id='${pkg%-cgi}'></a>**<br>"

L="$(grep -P '^[ \t]*help[ \t]*$' -nm1 "$MYPWD/$pkg/Config.in" 2>/dev/null | sed 's/:.*//')"
C="$(wc -l "$MYPWD/$pkg/Config.in" 2>/dev/null | sed 's/ .*//')"
[ -z "$L" -o -z "$C" ] && echo "nohelp1: $pkg" 1>&2 && continue
T=$(( $C - $L))
N="$(tail -n "$T" "$MYPWD/$pkg/Config.in" | grep -P "^[ \t]*(#|(end)*if|config|bool|string|int|depends on|(end)*menu|comment|menuconfig|(end)*choice|prompt|select|default|source|help)" -n | head -n1 | sed 's/:.*//')"
help="$(tail -n "$T" "$MYPWD/$pkg/Config.in" | head -n "$(( $N - 1 ))" | grep -vP '^[ \t]*$' | sed 's/[ \t]*$//g;s/^[ \t]*//g;s/$/ /g' | tr -d '\n' | sed 's/ $//')"
[ -z "$help" ] && echo "nohelp2: $pkg" 1>&2 && continue
echo "    $help"

done
done >> "$MYPWD/README.md"

