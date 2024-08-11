test $TMUX && return
test $SSH_TTY && return
test NO_DIFF || PAGER= git -C $HOME/.files diff -p

if test ! -e $HOME/.colors; then
cat <<EOF > $HOME/.colors
system: "base16"
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
EOF
fi

local colors=$(cat $HOME/.colors \
  | awk -F: '/base.*/ {print $1 $2}' \
  | awk -F" " '{ print "s/{{" $1 "-hex}}/" tolower($2) "/g"}' \
  | tr -d '"' \
  | tr "\n" ";"
)

alacritty_opacity=`$HOME/.alacritty.toml 2>/dev/null | awk '/^opacity/ {print $NF}'`

local hostname=$(hostname -s)
for dotfile in $(git -C $HOME/.files ls-files)
do
  mkdir -p `dirname $HOME/$dotfile`
  cat $HOME/.files/$dotfile \
    | sed -r "s/^[--;#\/\"\!]+${hostname} //g; /^#(carbon|mcbpro)/d" \
    | sed "${colors}" \
    > $HOME/$dotfile
done

sed "s/^opacity = .*/opacity = ${alacritty_opacity:-1.0}/" -i "$HOME/.alacritty.toml"

color_variant=$(cat $HOME/.colors | awk '/variant/ {print $2}' |  tr -d '"')
sed "s/^vim.opt.background = .*/vim.opt.background = '$color_variant'/g" -i "$HOME/.config/nvim/init.lua"

echo "$HOME/.files/ >> ${hostname} ($HOME/.zshenv) >> $HOME/"
