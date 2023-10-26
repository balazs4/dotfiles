
[[ $TMUX ]] && return
PAGER= git -C $HOME/.files diff -p
local hostname=`hostname -s`
local uname=`uname -s`

local colors=`cat <<EOF \
  | awk -F: '/base.*/ {print $1 $2}' \
  | awk -F" " '{ print "s/{{" $1 "-hex}}/" $2 "/g"}' \
  | tr -d '"' \
  | tr "\n" ";"
scheme: "Grayscale Light"
author: "Alexandre Gavioli (https://github.com/Alexx2/)"
base00: "f7f7f7"
base01: "e3e3e3"
base02: "b9b9b9"
base03: "ababab"
base04: "525252"
base05: "464646"
base06: "252525"
base07: "101010"
base08: "7c7c7c"
base09: "999999"
base0A: "a0a0a0"
base0B: "8e8e8e"
base0C: "868686"
base0D: "686868"
base0E: "747474"
base0F: "5e5e5e"
`

for dotfile in $(git -C $HOME/.files grep --name-only -- ${uname})
do
  echo $dotfile
  mkdir -p `dirname $HOME/$dotfile`
  cat $HOME/.files/$dotfile \
    | sed -r "s/^[--;#\/\"\!]+${hostname} //g;/^[#]+/d;" \
    | sed "${colors}" \
    > $HOME/$dotfile
done

echo "$HOME/.files/ >> ${uname} >> ${hostname} >> $HOME/"
