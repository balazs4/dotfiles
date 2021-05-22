git -C $HOME/.files pull || PAGER= git -C $HOME/.files diff -p 

for dotfile in `git -C $HOME/.files ls-files -- ':!:readme.md'`
do
  mkdir -p `dirname $HOME/$dotfile`
  sed "s|^[;#/\"\!]\+`hostname` ||g;s|^[\"#]\+${MODE:-dark} ||g" $HOME/.files/$dotfile  > $HOME/$dotfile
done
echo "$HOME/.files/ >> `hostname` >> $HOME"
