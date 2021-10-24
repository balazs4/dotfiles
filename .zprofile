[[ `env | grep TMUX | wc -l` -gt 0 ]] && return

PAGER= git -C $HOME/.files diff -p 

echo "$HOME/.files/ >> `hostname` >> $HOME/"
echo "================================================================="
for dotfile in `git -C $HOME/.files ls-files -- ':!:readme.md'`
do
  mkdir -p `dirname $HOME/$dotfile`
  sed "s|^[;#/\"\!]\+`hostname` ||g;s|^[\"#]\+${MODE:-dark} ||g" $HOME/.files/$dotfile  > $HOME/$dotfile
  echo "`hostname` >> $HOME/[.files/]$dotfile"
done
