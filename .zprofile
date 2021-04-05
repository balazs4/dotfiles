for dotfile in "`git -C $HOME/.dotfiles ls-files`"
do
  mkdir -p `dirname $HOME/$dotfile`
  sed "s|[;#/\"]\+`hostname` ||g" $dofile > $HOME/$dotfile
done
