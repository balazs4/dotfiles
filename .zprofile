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

# store current value
alacritty_opacity=`awk '/^opacity/ {print $NF}' $HOME/.alacritty.toml 2>/dev/null`

local hostname=$(hostname -s)
for dotfile in $(git -C $HOME/.files ls-files)
do
  mkdir -p `dirname $HOME/$dotfile`
  cat $HOME/.files/$dotfile \
    | sed -r "s/^[--;#\/\"\!]+${hostname} //g; /^#(carbon|mcbpro)/d" \
    | sed "${colors}" \
    > $HOME/$dotfile
done

#mcbpro alias sed='/opt/homebrew/bin/gsed'
# restore above stored value
sed "s/^opacity = .*/opacity = ${alacritty_opacity:-1.0}/" -i "$HOME/.alacritty.toml"

color_variant=$(cat $HOME/.colors | awk '/variant/ {print $2}' |  tr -d '"')

case "$color_variant" in
  "dark")
    echo "--force-dark-mode --enable-features=WebUIDarkMode" > $HOME/.config/chromium-flags.conf
    echo "--force-dark-mode --enable-features=WebUIDarkMode" > $HOME/.config/brave-flags.conf
    sed "s/^vim.opt.background = .*/vim.opt.background = 'dark'/g" -i "$HOME/.config/nvim/init.lua"
    sed "s/^set background=.*/set background=dark/g" -i "$HOME/.vimrc"
    ;;

  "light")
    echo "" > $HOME/.config/chromium-flags.conf
    echo "" > $HOME/.config/brave-flags.conf
    sed "s/^vim.opt.background = .*/vim.opt.background = 'light'/g" -i "$HOME/.config/nvim/init.lua"
    sed "s/^set background=.*/set background=light/g" -i "$HOME/.vimrc"
    ;;
esac



echo "$HOME/.files/ >> ${hostname} >> $HOME/"
