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
name: "Black Metal"
author: "metalelf0 (https://github.com/metalelf0)"
variant: "dark"
palette:
  base00: "000000"
  base01: "121212"
  base02: "222222"
  base03: "333333"
  base04: "999999"
  base05: "c1c1c1"
  base06: "999999"
  base07: "c1c1c1"
  base08: "5f8787"
  base09: "aaaaaa"
  base0A: "a06666"
  base0B: "dd9999"
  base0C: "aaaaaa"
  base0D: "888888"
  base0E: "999999"
  base0F: "444444"

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

