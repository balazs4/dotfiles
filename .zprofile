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
name: "PhD"
author: "Hennig Hasemann (http://leetless.de/vim.html)"
variant: "dark"
palette:
  base00: "061229"
  base01: "2a3448"
  base02: "4d5666"
  base03: "717885"
  base04: "9a99a3"
  base05: "b8bbc2"
  base06: "dbdde0"
  base07: "ffffff"
  base08: "d07346"
  base09: "f0a000"
  base0A: "fbd461"
  base0B: "99bf52"
  base0C: "72b9bf"
  base0D: "5299bf"
  base0E: "9989cc"
  base0F: "b08060"

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

