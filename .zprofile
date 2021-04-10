[[ `git -C $HOME/.files diff --name-only | wc -l` -eq 0 ]] \
  && git -C $HOME/.files pull \
  || git -C $HOME/.files diff -p
for dotfile in `git -C $HOME/.files ls-files -- ':!:readme.md'`
do
  mkdir -p `dirname $HOME/$dotfile`
  sed "s|[;#/\"\!]\+`hostname` ||g;s|#${MODE:-dark}||g" $HOME/.files/$dotfile  > $HOME/$dotfile
done
echo "$HOME/.files/ >> `hostname` >> $HOME"
