# Linux Darwin

[[ $TMUX ]] && return
PAGER= git -C $HOME/.files diff -p
local hostname=`hostname -s`
local uname=`uname -s`

# https://github.com/tinted-theming/base16-schemes
local colors=`cat <<EOF \
  | awk -F: '/base.*/ {print $1 $2}' \
  | awk -F" " '{ print "s/{{" $1 "-hex}}/" $2 "/g"}' \
  | tr -d '"' \
  | tr "\n" ";"
FOE
scheme: "Horizon Dark"
author: "Michaël Ball (http://github.com/michael-ball/)"
base00: "1C1E26"
base01: "232530"
base02: "2E303E"
base03: "6F6F70"
base04: "9DA0A2"
base05: "CBCED0"
base06: "DCDFE4"
base07: "E3E6EE"
base08: "E93C58"
base09: "E58D7D"
base0A: "EFB993"
base0B: "EFAF8E"
base0C: "24A8B4"
base0D: "DF5273"
base0E: "B072D1"
base0F: "E4A382"
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
