
[[ $TMUX ]] && return
PAGER= git -C $HOME/.files diff -p
local hostname=`hostname -s`
local uname=`uname -s`

local colors=`cat <<EOF \
  | awk -F: '/base.*/ {print $1 $2}' \
  | awk -F" " '{ print "s/{{" $1 "-hex}}/" $2 "/g"}' \
  | tr -d '"' \
  | tr "\n" ";"
scheme: "iA Light"
author: "iA Inc. (modified by aramisgithub)"
base00: "f6f6f6"
base01: "dedede"
base02: "bde5f2"
base03: "898989"
base04: "767676"
base05: "181818"
base06: "e8e8e8"
base07: "f8f8f8"
base08: "9c5a02"
base09: "c43e18"
base0A: "c48218"
base0B: "38781c"
base0C: "2d6bb1"
base0D: "48bac2"
base0E: "a94598"
base0F: "8b6c37"
`

for dotfile in $(git -C $HOME/.files grep --name-only -- ${uname})
do
  mkdir -p `dirname $HOME/$dotfile`
  cat $HOME/.files/$dotfile \
    | sed -r "s/^[--;#\/\"\!]+${hostname} //g;/^[#]+/d;" \
    | sed "${colors}" \
    > $HOME/$dotfile
done

echo "$HOME/.files/ >> ${uname} >> ${hostname} >> $HOME/"
