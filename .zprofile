# Linux Darwin

[[ $TMUX ]] && return
PAGER= git -C $HOME/.files diff -p
local hostname=`hostname -s`
local uname=`uname -s`

local colors=`cat <<EOF \
  | awk -F: '/base.*/ {print $1 $2}' \
  | awk -F" " '{ print "s/{{" $1 "-hex}}/" $2 "/g"}' \
  | tr -d '"' \
  | tr "\n" ";"

# curl https://github.com/dawikur/base16-gruvbox-scheme/blob/master/gruvbox-dark-soft.yaml
scheme: "Gruvbox dark, soft"
author: "Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)"
base00: "32302f" # ----
base01: "3c3836" # ---
base02: "504945" # --
base03: "665c54" # -
base04: "bdae93" # +
base05: "d5c4a1" # ++
base06: "ebdbb2" # +++
base07: "fbf1c7" # ++++
base08: "fb4934" # red
base09: "fe8019" # orange
base0A: "fabd2f" # yellow
base0B: "b8bb26" # green
base0C: "8ec07c" # aqua/cyan
base0D: "83a598" # blue
base0E: "d3869b" # purple
base0F: "d65d0e" # brown
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
