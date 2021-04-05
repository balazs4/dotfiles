for dotfile in `git -C ${SOURCE:-$HOME/.files} ls-files`
do
  [[ $HOME = `dirname ${TARGET:-$HOME}/$dotfile` ]] || mkdir -p `dirname ${TARGET:-$HOME}/$dotfile`
  sed "s|[;#/\"]\+`hostname` ||g" $dotfile > ${TARGET:-$HOME}/$dotfile
done
