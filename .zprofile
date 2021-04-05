for dotfile in "`git -C $HOME/.files ls-files | xargs`"
do
  mkdir -p `dirname $HOME/$dotfile`
  sed "s|[;#/\"]\+$HOSTNAME ||g" $dofile > $HOME/$dotfile
done
