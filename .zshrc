export TERM=xterm-termite
export LANG=en_US.UTF-8
function notignore(){
  $HOME/.file $1 >> $HOME/.gitignore && git add .gitignore $1 && git commit -m "add: $1"
}

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

export BROWSER=chromium
export EDITOR=vim

alias zshrc="vim $HOME/.zshrc; source $HOME/.zshrc"
alias vimrc="vim $HOME/.vimrc; vim +PlugInstall +PlugClean +qall"
alias wttr="curl -s 'http://wttr.in/91341?format=4'"
alias xx='xclip -selection clipboard'
alias v='vim +Rg!'

alias yolo='git add . && git commit -m "chore: `curl -s https://krautipsum.com/api/noun | fx .noun` :see_no_evil:" && sleep 2s && git push && curl --max-time 3 -s parrot.live || true'

export NPM_CONFIG_LOGLEVEL=http

alias foo='echo bar'

function http(){
  node -e 'Object.entries(require("http").STATUS_CODES).map(x=> x.join("-")).forEach(x=> process.stdout.write(`${x}\n`))'
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
