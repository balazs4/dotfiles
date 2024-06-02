test $TMUX && return
test $SSH_TTY && return
test NO_DIFF || PAGER= git -C $HOME/.files diff -p

local hostname=`hostname -s`

local colors=`cat <<EOF \
  | awk -F: '/base.*/ {print $1 $2}' \
  | awk -F" " '{ print "s/{{" $1 "-hex}}/" tolower($2) "/g"}' \
  | tr -d '"' \
  | tr "\n" ";"
FOE
system: "base16"
<<<<<<< HEAD
name: "Ayu Dark"
author: "Khue Nguyen <Z5483Y@gmail.com>"
variant: "dark"
palette:
  base00: "0F1419"
  base01: "131721"
  base02: "272D38"
  base03: "3E4B59"
  base04: "BFBDB6"
  base05: "E6E1CF"
  base06: "E6E1CF"
  base07: "F3F4F5"
  base08: "F07178"
  base09: "FF8F40"
  base0A: "FFB454"
  base0B: "B8CC52"
  base0C: "95E6CB"
  base0D: "59C2FF"
  base0E: "D2A6FF"
  base0F: "E6B673"
=======
name: "Catppuccin Macchiato"
author: "https://github.com/catppuccin/catppuccin"
variant: "dark"
palette:
  base00: "24273a" # base
  base01: "1e2030" # mantle
  base02: "363a4f" # surface0
  base03: "494d64" # surface1
  base04: "5b6078" # surface2
  base05: "cad3f5" # text
  base06: "f4dbd6" # rosewater
  base07: "b7bdf8" # lavender
  base08: "ed8796" # red
  base09: "f5a97f" # peach
  base0A: "eed49f" # yellow
  base0B: "a6da95" # green
  base0C: "8bd5ca" # teal
  base0D: "8aadf4" # blue
  base0E: "c6a0f6" # mauve
  base0F: "f0c6c6" # flamingo
>>>>>>> 836a772 (1717357262@carbon)

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

echo "$HOME/.files/ >> ${hostname} ($HOME/.zshenv) >> $HOME/"

