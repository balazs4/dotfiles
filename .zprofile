
[[ $TMUX ]] && return
PAGER= git -C $HOME/.files diff -p
local hostname=`hostname -s`
local uname=`uname -s`

local colors=`cat <<EOF \
  | awk -F: '/base.*/ {print $1 $2}' \
  | awk -F" " '{ print "s/{{" $1 "-hex}}/" $2 "/g"}' \
  | tr -d '"' \
  | tr "\n" ";"
# Ashes scheme for the Base16 Builder (https://github.com/chriskempson/base16-builder)
scheme: "Ashes"
author: "Jannik Siebert (https://github.com/janniks)"
base00: "1C2023" # ----
base01: "393F45" # ---
base02: "565E65" # --
base03: "747C84" # -
base04: "ADB3BA" # +
base05: "C7CCD1" # ++
base06: "DFE2E5" # +++
base07: "F3F4F5" # ++++
base08: "C7AE95" # orange
base09: "C7C795" # yellow
base0A: "AEC795" # poison green
base0B: "95C7AE" # turquois
base0C: "95AEC7" # aqua
base0D: "AE95C7" # purple
base0E: "C795AE" # pink
base0F: "C79595" # light red
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
