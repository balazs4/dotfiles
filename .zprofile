
[[ $TMUX ]] && return
PAGER= git -C $HOME/.files diff -p
local hostname=`hostname -s`
local uname=`uname -s`

local colors=`cat <<EOF \
  | awk -F: '/base.*/ {print $1 $2}' \
  | awk -F" " '{ print "s/{{" $1 "-hex}}/" $2 "/g"}' \
  | tr -d '"' \
  | tr "\n" ";"
scheme: "Gruvbox Material Light, Medium"
author: "Mayush Kumar (https://github.com/MayushKumar), sainnhe (https://github.com/sainnhe/gruvbox-material-vscode)"
base00: "fbf1c7"
base01: "f2e5bc"
base02: "d5c4a1"
base03: "bdae93"
base04: "665c54"
base05: "654735"
base06: "3c3836"
base07: "282828"
base08: "c14a4a"
base09: "c35e0a"
base0A: "b47109"
base0B: "6c782e"
base0C: "4c7a5d"
base0D: "45707a"
base0E: "945e80"
base0F: "e78a4e"
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
