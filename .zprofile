for dotfile in `git -C $HOME/.files ls-files -- ':!:readme.md'`
do
  echo " >> $dotfile"
  mkdir -p `dirname $HOME/$dotfile`
  sed "s|[;#/\"]\+`hostname` ||g;s|#${MODE:-dark}||g" $HOME/.files/$dotfile  > $HOME/$dotfile
done
