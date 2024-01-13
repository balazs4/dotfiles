[[ $TMUX ]] && return
PAGER= git -C $HOME/.files diff -p
local hostname=`hostname -s`

local colors=`cat <<EOF \
  | awk -F: '/base.*/ {print $1 $2}' \
  | awk -F" " '{ print "s/{{" $1 "-hex}}/" tolower($2) "/g"}' \
  | tr -d '"' \
  | tr "\n" ";"
FOE
system: "base16"
name: "Gruvbox Material Dark, Hard"
author: "Mayush Kumar (https://github.com/MayushKumar), sainnhe (https://github.com/sainnhe/gruvbox-material-vscode)"
variant: "dark"
palette:
  base00: "202020"
  base01: "2a2827"
  base02: "504945"
  base03: "5a524c"
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

for dotfile in $(git -C $HOME/.files ls-files)
do
  mkdir -p `dirname $HOME/$dotfile`
  cat $HOME/.files/$dotfile \
    | sed -r "s/^[--;#\/\"\!]+${hostname} //g;/^[#]+/d;" \
    | sed "${colors}" \
    > $HOME/$dotfile
done

echo "$HOME/.files/ >> ${hostname} >> $HOME/"
