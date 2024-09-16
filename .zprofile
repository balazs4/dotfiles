#mcbpro alias sed='/opt/homebrew/bin/gsed'
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
  | awk -F: '/base0.?/ {print $1 $2} /variant/ {print $1 $2}' \
  | tr -d '"' \
  | awk -F" " '{ print "s/{{" $1 "}}/" tolower($2) "/g"}' \
  | sed -E 's/(base0.?)/\1-hex/g' \
  | tr "\n" ";"
)

local current_opacity=$(awk '/^opacity/ {print $NF}' "$HOME/.alacritty.toml" 2>/dev/null)
local opacity=$(printf "s/{{%s}}/%s/g;s/{{%s}}/1.00/g" "opacity" "$current_opacity" "opacity")

local hostname=$(hostname -s)

for dotfile in $(git -C $HOME/.files ls-files)
do
  mkdir -p `dirname $HOME/$dotfile`
  cat $HOME/.files/$dotfile \
    | sed -r "s/^[--;#\/\"\!]+${hostname} //g; /^#(carbon|mcbpro)/d" \
    | sed "${colors}" \
    | sed "${opacity}" \
    > $HOME/$dotfile
done

echo "$HOME/.files/ >> ${hostname} >> $HOME/"
