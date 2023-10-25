
[[ $TMUX ]] && return
PAGER= git -C $HOME/.files diff -p
local hostname=`hostname -s`
local uname=`uname -s`

local colors=`cat <<EOF \
  | awk -F: '/base.*/ {print $1 $2}' \
  | awk -F" " '{ print "s/{{" $1 "-hex}}/" $2 "/g"}' \
  | tr -d '"' \
  | tr "\n" ";"
scheme: "iA Dark"
author: "iA Inc. (modified by aramisgithub)"
base00: "1a1a1a"
base01: "222222"
base02: "1d414d"
base03: "767676"
base04: "b8b8b8"
base05: "cccccc"
base06: "e8e8e8"
base07: "f8f8f8"
base08: "d88568"
base09: "d86868"
base0A: "b99353"
base0B: "83a471"
base0C: "7c9cae"
base0D: "8eccdd"
base0E: "b98eb2"
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
