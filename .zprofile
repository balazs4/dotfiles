# Linux Darwin

[[ $TMUX ]] && return
PAGER= git -C $HOME/.files diff -p
local hostname=`hostname -s | sed 's/macbookpro/mcbpro/g'` #how can i change hostname on macos? for real?
local uname=`uname -s`

for dotfile in $(git -C $HOME/.files grep --name-only -- ${uname})
do
  mkdir -p `dirname $HOME/$dotfile`
  sed -r "s/^[--;#\/\"\!]+${hostname} //g;/^[#]+/d" $HOME/.files/$dotfile  > $HOME/$dotfile
done

echo "$HOME/.files/ >> ${uname} >> ${hostname} >> $HOME/"
