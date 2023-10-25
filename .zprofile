
[[ $TMUX ]] && return
PAGER= git -C $HOME/.files diff -p
local hostname=`hostname -s`
local uname=`uname -s`

local colors=`cat <<EOF \
  | awk -F: '/base.*/ {print $1 $2}' \
  | awk -F" " '{ print "s/{{" $1 "-hex}}/" $2 "/g"}' \
  | tr -d '"' \
  | tr "\n" ";"
scheme: "Ayu Light"
author: "Khue Nguyen <Z5483Y@gmail.com>"
base00: "FAFAFA"
base01: "F3F4F5"
base02: "F8F9FA"
base03: "ABB0B6"
base04: "828C99"
base05: "5C6773"
base06: "242936"
base07: "1A1F29"
base08: "F07178"
base09: "FA8D3E"
base0A: "F2AE49"
base0B: "86B300"
base0C: "4CBF99"
base0D: "36A3D9"
base0E: "A37ACC"
base0F: "E6BA7E"
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
