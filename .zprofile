# Linux Darwin
[[ $TMUX ]] && return
PAGER= git -C $HOME/.files diff -p
local hostname=`hostname -s`
local uname=`uname -s`

local colors=`cat <<EOF \
  | awk -F: '/base.*/ {print $1 $2}' \
  | awk -F" " '{ print "s/{{" $1 "-hex}}/" tolower($2) "/g"}' \
  | tr -d '"' \
  | tr "\n" ";"
FOE
scheme: "Gruvbox Material Dark, Medium"
author: "Mayush Kumar (https://github.com/MayushKumar), sainnhe (https://github.com/sainnhe/gruvbox-material-vscode)"
base00: "292828"
base01: "32302f"
base02: "504945"
base03: "665c54"
base04: "bdae93"
base05: "ddc7a1"
base06: "ebdbb2"
base07: "fbf1c7"
base08: "ea6962"
base09: "e78a4e"
base0A: "d8a657"
base0B: "a9b665"
base0C: "89b482"
base0D: "7daea3"
base0E: "d3869b"
base0F: "bd6f3e"

EOF
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
