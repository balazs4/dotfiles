# Linux Darwin

[[ $TMUX ]] && return
PAGER= git -C $HOME/.files diff -p

for dotfile in $(git -C $HOME/.files grep --name-only -- `uname -s`)
do
  mkdir -p `dirname $HOME/$dotfile`
  sed -r "s/^[--;#\/\"\!]+`hostname -s` //g;/^[#]+/d" $HOME/.files/$dotfile  > $HOME/$dotfile
done

echo "$HOME/.files/ >> `uname -s` >> `hostname -s` >> $HOME/"
