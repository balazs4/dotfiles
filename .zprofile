test $TMUX && return
test NO_DIFF || PAGER= git -C $HOME/.files diff -p

local hostname=`hostname -s`

local colors=`cat <<EOF \
  | awk -F: '/base.*/ {print $1 $2}' \
  | awk -F" " '{ print "s/{{" $1 "-hex}}/" tolower($2) "/g"}' \
  | tr -d '"' \
  | tr "\n" ";"
FOE
system: "base16"
name: "Grayscale Dark (modified)"
author: "Alexandre Gavioli (https://github.com/Alexx2/), balazs4 (https://github.com/balazs4)"
variant: "dark"
palette:
  base00: "000000"
  base01: "141414"
  base02: "131313"
  base03: "525252"
  base04: "ababab"
  base05: "cacaca"
  base06: "e3e3e3"
  base07: "f7f7f7"
  base08: "f73e47"
  base09: "ff5e00"
  base0A: "a0a0a0"
  base0B: "bde009"
  base0C: "868686"
  base0D: "686868"
  base0E: "747474"
  base0F: "5e5e5e"

EOF
`
source $HOME/.zshenv

for dotfile in $(git -C $HOME/.files ls-files)
do
  mkdir -p `dirname $HOME/$dotfile`
  cat $HOME/.files/$dotfile \
    | sed -r "s/^[--;#\/\"\!]+${hostname} //g;/^[#]+/d;" \
    | sed "${colors}" \
    | sed "s/^opacity = .*/opacity = ${ALACRITTY_OPACITY:-1.0}/" \
    > $HOME/$dotfile
done

echo "$HOME/.files/ >> ${hostname}($HOME/.zshenv) >> $HOME/"

