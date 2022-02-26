#!/bin/sh
# Linux Darwin

[[ $TMUX ]] && return
PAGER= git -C $HOME/.files diff -p

for dotfile in `git -C $HOME/.files ls-files -- ':!:readme.md'`
do
  if head -2 $dotfile | grep `uname -s` > /dev/null
  then
    test $DOT && echo -e "\e[32mUSE\t$dotfile\e[0m"
  else
    test $DOT && echo -e "\e[31mSKIP\t$dotfile\e[0m"
    continue
  fi

  mkdir -p `dirname $HOME/$dotfile`
  sed -r "s|^[;#/\"\!]+`hostname -s` ||g" $HOME/.files/$dotfile  > $HOME/$dotfile
done

echo "$HOME/.files/ >> `uname -s` >> `hostname -s` >> $HOME/"
