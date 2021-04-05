for dotfile in `git -C $HOME/.files ls-files`
do
  echo $dotfile
  mkdir -p `dirname $HOME/$dotfile`
  sed "s|[;#/\"]\+`hostname` ||g" $HOME/.files/$dotfile  > $HOME/$dotfile
done
