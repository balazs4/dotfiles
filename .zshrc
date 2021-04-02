HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=10000
setopt appendhistory     #Append history to the history file (no overwriting)
setopt sharehistory      #Share history across terminals
setopt incappendhistory  #Immediately append to the history file, not just when a term is killed
## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zmodload zsh/complist

export KEYTIMEOUT=1

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '\e[A' history-beginning-search-backward-end
bindkey '\e[B' history-beginning-search-forward-end

function zsh-git() {
  [[ $PWD = $HOME ]] && exit 0
  local __branch=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  [[ -z $__branch ]] && exit 0
  [[ `git rev-parse --show-toplevel` = "$HOME" ]] && exit 0

  local __staged=`PAGER= git diff --name-only --staged | wc -l`
  local __changed=`PAGER= git diff --name-only | wc -l`
  local __notpushed=`PAGER= git diff --name-only origin/$__branch..HEAD 2>/dev/null | wc -l`

  local _branch=`[[ __notpushed -eq 0 ]] && echo %F{white}$__branch%f || echo %F{yellow}$__branch%f`
  #light local _branch=`[[ __notpushed -eq 0 ]] && echo $__branch || echo %F{yellow}$__branch%f`
  local _staged=`[[ __staged -eq 0 ]] && echo $__staged || echo %B%F{green}$__staged%f%b`
  #light local _staged=`[[ __staged -eq 0 ]] && echo $__staged || echo %B%F{blue}$__staged%f%b`
  local _changed=`[[ __changed -eq 0 ]] && echo $__changed || echo %B%F{red}$__changed%f%b`

  echo " [ $_branch«$_staged«$_changed ]"
}

setopt PROMPT_SUBST
PROMPT='%B%F{white} ▲ %~%f%b$(zsh-git) %B%F{white}»%f%b '
RPROMPT='%(?.%F{white}.%F{red})%?%f'

#light PROMPT='%B%F{black} ▲ %~%f%b$(zsh-git) %B%F{black}»%f%b '
#light RPROMPT='%(?.%F{black}.%F{red})%?%f'

[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh
[[ -r "/usr/share/fzf/completion.zsh" ]] && source /usr/share/fzf/completion.zsh
[[ -r "/usr/share/fzf/key-bindings.zsh" ]] && source /usr/share/fzf/key-bindings.zsh

export LANG=en_US.UTF-8
export BROWSER=chromium
export EDITOR=vim
export NPM_CONFIG_LOGLEVEL=http
export FZF_DEFAULT_COMMAND="fd --hidden --type=f -E node_modules -E .git"
export FZF_DEFAULT_OPTS="--sync"
export GPG_TTY=`tty`

alias zshrc="vim $HOME/.zshrc; source $HOME/.zshrc"
alias vimrc="vim $HOME/.vimrc"
alias wttr="curl -s 'http://wttr.in/91085?format=3'"
alias xx='xclip -selection clipboard'
alias v=vim
alias ls='ls --color=auto'
alias grep='grep --color'
alias tree='tree -I node_modules'
alias :q='exit'
alias :x='exit'
alias ll='ls -lsh'
alias rm='rm -i'
alias yolo='git add . && git commit -m "`bob yolo commit` :sponge:" && git push || true'
alias foo='echo bar'
alias http="node -p \"Object.entries(require('http').STATUS_CODES).map(x=> x.join('\t')).join('\n')\" | fzf"
alias emoji='emojify --list | sed "0,/Supported emojis/d"'
alias mc='mc -b'
alias ssh='TERM=xterm-256color ssh'
alias gd='git diff'
alias gst='git status'
alias gco='git checkout'
alias gpp='git pull --prune --tags'
alias gcm='git checkout master'
alias shrug='curl -s http://shrug.io | xx'
alias markdownlint='npx -q -p markdownlint-cli markdownlint **/*.md --ignore node_modules --fix'
alias wipe='docker rm -f `docker ps -aq`; docker volume prune -f'
alias dco='docker-compose'
alias spotify='google-chrome-stable --app=https://open.spotify.com/' #webapp
alias youtube='chromium --app=https://youtube.com/' #webapp
alias whatsapp='chromium --app=https://web.whatsapp.com/' #webapp
alias root='cd `git rev-parse --show-toplevel`'
alias rg='rg --hidden'
alias p5="docker-compose --file $HOME/git/plossys-bundle/docker-compose.yml"
alias infra="GH_REPO=sealsystems/com-infrastructure gh"

function notignore(){
  $HOME/.file $1 >> $HOME/.gitignore && git add .gitignore $1 && git commit -m "add: $1"
}

function light(){
  sed -i 's/#light //g' $HOME/.config/termite/config && killall -USR1 termite
  sed -i 's/#light //g' $HOME/.zshrc && source $HOME/.zshrc
}

function dark(){
  git -C $HOME stash
  source $HOME/.zshrc
  killall -USR1 termite
}

function yt(){
  local search=`echo $* | sed 's/\s/+/g'`
  curl -s "https://www.youtube.com/results?search_query=$search" \
    | pup 'script:contains("var ytInitialData") text{}' \
    | sed 's/var ytInitialData = //g;s/};/}/' \
    | fx youtubevideos \
    | fzf \
    | cut -f1 \
    | xargs -Iwatch mpv $MPV https://youtu.be/watch
}
alias yta="MPV='--no-video' yt"

function radio(){
  term=$(echo $* | sed -r 's/\s/\+/g')
  curl http://opml.radiotime.com/Search.ashx\?query\=$term -s \
    | npx -q -p fast-xml-parser xml2js \
    | fx 'xx => xx.opml.body.outline.filter(x => x["@_item"] === "station").map(x=>[ x["@_URL"], x["@_reliability"], x["@_text"], x["@_subtext"] ].join("\t")).join("\n")' \
    | fzf \
    | cut -f1 \
    | mpv --playlist=-
}

function dw(){
  url="https://de.wiktionary.org/wiki/$1"
  curl -s "$url" | pup 'table.wikitable' | w3m -dump -T text/html | sed '/^$/d'
  echo $url
}

function todos(){
  case "$1" in
    edit)
      vim "+set number" $HOME/.todos
      ;;
    *)
      cat $HOME/.todos | fzf
      ;;
  esac
}


function record(){
  if [ "$1" = "window" ]
  then
    eval $(xwininfo |
      sed -n -e "s/^ \+Absolute upper-left X: \+\([0-9]\+\).*/x=\1/p" \
             -e "s/^ \+Absolute upper-left Y: \+\([0-9]\+\).*/y=\1/p" \
             -e "s/^ \+Width: \+\([0-9]\+\).*/w=\1/p" \
             -e "s/^ \+Height: \+\([0-9]\+\).*/h=\1/p" )
  fi

  FILENAME=/tmp/$(date "+%Y%m%d_%H%M%S").mp4
  ffmpeg -f x11grab -r 30 -s ${w:-1920}x${h:-1080} -i :0.0+${x:-0},${y:-0} -q:v 0 -q:a 0 $FILENAME
  echo $FILENAME
}

function npmrc(){
  if [[ $1 = 'current' ]]
  then
    cat ~/.npmrc | grep registry= | cut -f3 -d"/"
  else
    NPMRC_SUFFIX=${1:-`find $HOME -maxdepth 1 -name '.npmrc.*' | fzf --preview 'cat {}' | cut -d "." -f3`}
    cp -f ~/.npmrc ~/.npmrc.prev
    cp -f ~/.npmrc.$NPMRC_SUFFIX ~/.npmrc
    NPM_CONFIG_LOGLEVEL=silent npm cache clean -f
  fi
}

export N_PREFIX=$HOME/.n/prefix
export PATH=$HOME/.n/:$N_PREFIX/bin/:$HOME/.gem/ruby/2.7.0/bin:${PATH}
export RUBYOPT="-W0"  # ruby warnings
export HOST_IP=`ip addr show ens33 | grep -Po 'inet \K[\d.]+'`
export ELASTICSEARCH_IP=`ip addr show ens33 | grep -Po 'inet \K[\d.]+'`

alias outlook='chromium --app=https://outlook.office365.com/mail/inbox' #webapp
alias teams='chromium --app="https://teams.microsoft.com/_#/conversations/General?threadId=19:1e2f67587cad457580ed4b3908f67431@thread.tacv2&ctx=channel"' #webapp
alias slack='chromium --app="$SLACK_URL"' #webapp
alias mongodb-rs='docker run --rm -p "27017:27017" ghcr.io/sealsystems/mongodb-rs:3.6.17'
function checkin() {
  npm run --silent --prefix=$HOME/src/timesheet checkin `date -d "${*:-0 minutes ago}" -u "+%Y-%m-%dT%TZ"`
  git -C $HOME/src/timesheet commit -am '☕ checkin'
  git -C $HOME/src/timesheet push --no-verify
}
function checkout(){
  npm run --silent --prefix=$HOME/src/timesheet checkout `date -d "${*:-0 minutes ago}" -u "+%Y-%m-%dT%TZ"`
  git -C $HOME/src/timesheet commit -am '🍺 checkout'
  git -C $HOME/src/timesheet push --no-verify
}
function bcs() {
  npm run --silent --prefix=$HOME/src/timesheet start \
    | fx 'x => Object.entries(x).map(([day,duration]) => `${day}\t${duration}`).join("\n")' \
    | fzf --layout=reverse
}
function fa(){
  npm run --silent --prefix=$HOME/src/timesheet start \
    | fx 'x => Object.entries(x).map(([day,duration]) => `${day}\t${duration}`).join("\n")' \
    | sort \
    | tail -1 \
    | cut -f2
}

function jira-md(){
  curl -u "`pass seal/jira`" -is "$JIRA_URL/jira/rest/api/2/search?jql=key=$1" | alola | fx jira 
}

function jira(){
  jira-md $1 | glow -
}

function rapid(){
  curl -u "`pass seal/jira`" -is "$JIRA_URL/jira/rest/greenhopper/1.0/xboard/work/allData.json?rapidViewId=$1" | alola | fx rapid
}

function sprint(){
  rapid 131 | fzf -q "'bv" --preview 'echo {} | cut -f1 | xargs -Iid zsh -c "source ~/.zshrc; jira id"'
}


function re(){
  docker-compose rm -sf $1
  docker-compose up $1
}

function co(){
  for handle in "$@"
  do
    echo "Co-authored-by: $handle <$handle@users.noreply.github.com>"
  done
}

function seal(){
  case "$1" in
    list)
      curl -H 'Cache-Control: no-cache' -s "https://$GITHUB_TOKEN@raw.githubusercontent.com/sealsystems/seal-parrot/master/betonieren.md" | sed 's/- //'
      ;;
    latest)
      curl -H 'Cache-Control: no-cache' -s "https://$GITHUB_TOKEN@raw.githubusercontent.com/sealsystems/seal-parrot/master/betonieren.md" | tail -1 | sed 's/- //'
      ;;
    *)
      curl -H 'Cache-Control: no-cache' -s "https://$GITHUB_TOKEN@raw.githubusercontent.com/sealsystems/seal-parrot/master/betonieren.md" | shuf -n1 | sed 's/- //'
      ;;
  esac
}

function mirrorlist() {
  COUNTRIES=`echo ${*:-DE NL}| xargs -d" " -I{} echo -n "&country={}"`
  curl -s "https://archlinux.org/mirrorlist/?protocol=https&ip_version=4${COUNTRIES}" \
    | sed "s/#Server/Server/g" \
    | sudo tee /etc/pacman.d/mirrorlist
}


alias bob="node -p \"process.argv.slice(1).map(w => w.split('').map((c,i)=>Math.random()>0.5?c.toUpperCase():c.toLowerCase()).join('')).join(' ')\""

function q() {
  docker-compose --file $HOME/git/plossys-bundle/docker-compose.yml exec db mongo --ssl --sslAllowInvalidCertificates spooler-$1 --eval "db.$1.find($2)" \
    | sed '0,/server version/d'
}
