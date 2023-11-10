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
scheme: "Github"
author: "Defman21"
base00: "ffffff"
base01: "f5f5f5"
base02: "c8c8fa"
base03: "969896"
base04: "e8e8e8"
base05: "333333"
base06: "ffffff"
base07: "ffffff"
base08: "ed6a43"
base09: "0086b3"
base0A: "795da3"
base0B: "183691"
base0C: "183691"
base0D: "795da3"
base0E: "a71d5d"
base0F: "333333"

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
