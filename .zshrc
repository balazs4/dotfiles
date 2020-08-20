export ZSH=$HOME/.oh-my-zsh/
plugins=(git z fzf)
source $ZSH/oh-my-zsh.sh

#ZSH_THEME="node"

GREEN="%{$fg_bold[green]%}"
YELLOW="%{$fg_bold[yellow]%}"
CYAN="%{$fg_bold[cyan]%}"
RED="%{$fg_bold[red]%}"
GREY="%{$fg_bold[grey]%}"
RESET="%{$reset_color%}"

PROMPT='$GREEN⬢ $YELLOW%~ $(git_prompt_info)$RESET'
RPROMPT='%(?.$GREY.$RED)$?$GREY ⬢ $RESET'

ZSH_THEME_GIT_PROMPT_PREFIX=" $CYAN"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" $RED⦿ "
ZSH_THEME_GIT_PROMPT_CLEAN=" $GREEN⦾ "

export LANG=en_US.UTF-8
export BROWSER=chromium
export EDITOR=vim
export NPM_CONFIG_LOGLEVEL=http
export NPM_CONFIG_PREFIX=$HOME/.node_modules_global
export PATH=$NPM_CONFIG_PREFIX/bin:$PATH

alias zshrc="vim $HOME/.zshrc; source $HOME/.zshrc"
alias vimrc="vim $HOME/.vimrc; vim +PlugInstall +PlugClean +qall"
alias wttr="curl -s 'http://wttr.in/91341?format=4'"
alias xx='xclip -selection clipboard'
alias v='vim +Rg!'
alias ls='ls --color=auto'
alias grep='grep --color'
alias tree='tree -I node_modules'
alias :q='exit'
alias :x='exit'
alias ll='ls -lsh'
alias rm='rm -i'
alias yolo='git add . && git commit -m "chore: `curl -s https://krautipsum.com/api/noun | fx .noun` :see_no_evil:"  && git push || true'
alias foo='echo bar'
alias now=vercel
alias http="node -p \"Object.entries(require('http').STATUS_CODES).map(x=> x.join('\t')).join('\n')\" | fzf"
alias video='mpv --playlist=-'
alias audio='mpv --no-video --playlist=-'
alias emoji='emojify --list | sed "0,/Supported emojis/d" | fzf'

function notignore(){
  $HOME/.file $1 >> $HOME/.gitignore && git add .gitignore $1 && git commit -m "add: $1"
}

function light(){
  curl -sf https://raw.githubusercontent.com/khamer/base16-termite/master/themes/base16-github.config >> ~/.config/termite/config
  killall -USR1 termite
  echo -e "
  \" mode: light
  colorscheme github
  let g:lightline = { 'colorscheme' : 'github' }
  " >> ~/.vimrc
}

function dark(){
  curl -sf https://raw.githubusercontent.com/khamer/base16-termite/master/themes/base16-brewer.config >> ~/.config/termite/config
  killall -USR1 termite
  echo -e "
  \" mode: dark
  colorscheme monochrome
  let g:lightline = { 'colorscheme' : 'powerline' }
  " >> ~/.vimrc
}

function yt(){
  if [ -z $1 ]
  then
    mpv `cat ~/.youtube | sort | uniq | fzf | cut -f1`
  else
    (sleep 10s; playerctl metadata --format "{{xesam:url}}	{{title}}" >> ~/.youtube) &  mpv $1
  fi
}
