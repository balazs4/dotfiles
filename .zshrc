export ZSH=$HOME/.oh-my-zsh/
DISABLE_AUTO_UPDATE=true
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
export NPM_CONFIG_PREFIX=$HOME/.npm_global
export PATH=$NPM_CONFIG_PREFIX/bin:$PATH
export FZF_DEFAULT_COMMAND="find . -type f -not -path './node_modules/*' -not -path './.git/*' | sed 's/\.\///'"

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
alias emoji='emojify --list | sed "0,/Supported emojis/d"'
alias docker='sudo docker'
alias todos='cat ~/.todos | fzf'

# webapps
alias whatsapp='google-chrome-stable --user-data-dir=$HOME/.config/webapp/whatsapp --app=https://web.whatsapp.com'
alias outlook='google-chrome-stable --user-data-dir=$HOME/.config/webapp/microsoft --app=https://outlook.com'
alias spotify='google-chrome-stable --user-data-dir=$HOME/.config/webapp/spotify --app=https://open.spotify.com/'
alias blau='google-chrome-stable --user-data-dir=$HOME/.config/webapp/shop https://blau.de'
alias amazon='google-chrome-stable --user-data-dir=$HOME/.config/webapp/shop https://amazon.de'
alias bank='google-chrome-stable --user-data-dir=$HOME/.config/webapp/bank'
alias google='google-chrome-stable --user-data-dir=$HOME/.config/webapp/google'

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

function radio(){
  term=$(echo $* | sed -r 's/\s/\+/g')
  curl http://opml.radiotime.com/Search.ashx\?query\=$term -s \
    | npx -p fast-xml-parser xml2js \
    | fx 'xx => xx.opml.body.outline.filter(x => x["@_item"] === "station").map(x=>[ x["@_URL"], x["@_reliability"], x["@_text"], x["@_subtext"] ].join("\t")).join("\n")' \
    | fzf \
    | cut -f1 \
    | mpv --playlist=-
}

function one-time-server() {
  node -p "require('http').createServer((q,s) => {s.writeHead(200, { 'content-type': process.argv[1] || 'text/plain'}); process.stdin.on('end', process.exit).pipe(s); }).listen().address().port"
}

alias one-time-server-qr='one-time-server | npx -q qrcode-terminal'
