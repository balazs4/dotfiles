
[[ $TMUX ]] && return
PAGER= git -C $HOME/.files diff -p
local hostname=`hostname -s`
local uname=`uname -s`

local colors=`cat <<EOF \
  | awk -F: '/base.*/ {print $1 $2}' \
  | awk -F" " '{ print "s/{{" $1 "-hex}}/" $2 "/g"}' \
  | tr -d '"' \
  | tr "\n" ";"
scheme: "Da One Gray"
author: "NNB (https://github.com/NNBnh)"
base00: "181818"
base01: "282828"
base02: "585858"
base03: "888888"
base04: "c8c8c8"
base05: "ffffff"
base06: "ffffff"
base07: "ffffff"
base08: "fa7883"
base09: "ffc387"
base0A: "ff9470"
base0B: "98c379"
base0C: "8af5ff"
base0D: "6bb8ff"
base0E: "e799ff"
base0F: "b3684f"
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
