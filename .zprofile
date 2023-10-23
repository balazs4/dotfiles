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

scheme: "Ayu Mirage"
author: "Khue Nguyen <Z5483Y@gmail.com>"
base00: "171B24"
base01: "1F2430"
base02: "242936"
base03: "707A8C"
base04: "8A9199"
base05: "CCCAC2"
base06: "D9D7CE"
base07: "F3F4F5"
base08: "F28779"
base09: "FFAD66"
base0A: "FFD173"
base0B: "D5FF80"
base0C: "95E6CB"
base0D: "5CCFE6"
base0E: "D4BFFF"
base0F: "F29E74"

EOF`

for dotfile in $(git -C $HOME/.files grep --name-only -- ${uname})
do
  mkdir -p `dirname $HOME/$dotfile`
  cat $HOME/.files/$dotfile \
    | sed -r "s/^[--;#\/\"\!]+${hostname} //g;/^[#]+/d;" \
    | sed "${colors}" \
    > $HOME/$dotfile
done

echo "$HOME/.files/ >> ${uname} >> ${hostname} >> $HOME/"
