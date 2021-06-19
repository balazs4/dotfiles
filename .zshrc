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
  local __branch=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  [[ -z $__branch ]] && return

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

zle-keymap-select () {
  if [ $KEYMAP = vicmd ]; then
    echo -ne "\033]12;Orange1\007"
  else
    echo -ne "\033]12;Magenta1\007"
  fi
}
zle -N zle-keymap-select

zle-line-init () {
  zle -K viins
  echo -ne "\033]12;Magenta1\007"
}
zle -N zle-line-init


setopt PROMPT_SUBST
PROMPT='%B%F{white} ▲ %~%f%b$(zsh-git) %B%F{white}»%f%b '
RPROMPT='%(?.%F{white}.%F{red})%?%f'

#light PROMPT='%B%F{black} ▲ %~%f%b$(zsh-git) %B%F{black}»%f%b '
#light RPROMPT='%(?.%F{black}.%F{red})%?%f'

[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh
[[ -r "/usr/share/fzf/completion.zsh" ]] && source /usr/share/fzf/completion.zsh
[[ -r "/usr/share/fzf/key-bindings.zsh" ]] && source /usr/share/fzf/key-bindings.zsh

export LANG=en_US.UTF-8
export TERMINAL=termite
export TERM=xterm-256color
export BROWSER=chromium
export EDITOR=vim
export NPM_CONFIG_LOGLEVEL=http
export FZF_DEFAULT_COMMAND="fd --hidden --type=f -E node_modules -E .git"
export FZF_DEFAULT_OPTS="--sync"
export GPG_TTY=`tty`

function dot(){
  pushd $HOME/.files > /dev/null
    vim ${1:-$PWD}
    source $PWD/.zprofile
  popd > /dev/null
}

function dotsync(){
  git -C $HOME/.files commit -am "`date +%s`@`hostname`"
  git -C $HOME/.files push
  git -C $HOME/.files pull
  source $HOME/.files/.zprofile
}

function dotfile(){
  [[ -e "$HOME/$1" ]] || return
  dir=`dirname "$HOME/.files/$1"`
  mkdir -p $dir
  cp -v "$HOME/$1" "$HOME/.files/$1"
  git -C "$HOME/.files/" add "$1" 
  git -C "$HOME/.files/" commit -m "add: $1"
}

function vimplug(){
  if [[ ! -z "$1" ]]
  then
    echo "\n\"$1" >> $HOME/.files/.vimrc
    source $HOME/.files/.zprofile
  fi

  rm -rf $HOME/.vim/pack/_/opt/*
  pushd $HOME/.vim/pack/_/opt/
    cat $HOME/.vimrc | grep github | sed 's/"//g' \
      | xargs -I{} git clone {} --depth 1
  popd
}

alias zshrc="dot .zshrc; source $HOME/.zshrc"
alias vimrc="dot .vimrc"
alias sx="dot .config/sxhkd/sxhkdrc; killall -USR1 sxhkd"
alias wttr="curl -s 'http://wttr.in/91085?format=3'"
alias xx='xclip -rmlastnl -selection clipboard'
alias v=vim
alias ls='ls --color=auto'
alias grep='grep --color'
alias tree='tree -I node_modules'
alias :q='exit'
alias :q!='exit'
alias ll='ls -lsh'
alias rm='rm -i'
alias bob="node -p \"process.argv.slice(1).map(w => w.split('').map((c,i)=>Math.random()>0.5?c.toUpperCase():c.toLowerCase()).join('')).join(' ')\""
alias yolo='git add . && git commit -m "`bob yolo commit` :sponge:" && git push --no-verify || true'
alias foo='echo bar'
alias http="node -p \"Object.entries(require('http').STATUS_CODES).map(x=> x.join('\t')).join('\n')\" | fzf"
alias mc='mc -b'
alias ssh='TERM=xterm-256color ssh'
alias gd='git diff'
alias gst='git status'
alias gco='git checkout'
alias gpp='git pull --prune --tags'
alias gcm='git checkout master'
alias shrug='curl -s http://shrug.io | xx'
alias wipe='docker rm -f `docker ps -aq`; docker volume prune -f'
alias dco='docker-compose'
alias rg='rg --hidden'
alias dmesg='sudo dmesg'
alias cal='LC_ALL=de_DE.utf8 cal'
alias yay='yay --editmenu'

function rgv(){
  rg --vimgrep $* | vim -q /dev/stdin
}

# persist MODE between sessions
#dark export MODE=dark
#light export MODE=light

function light(){
  MODE=light source $HOME/.zprofile
  source $HOME/.zshrc
  killall -USR1 termite
  i3-msg restart
}

function dark(){
  MODE=dark source $HOME/.zprofile
  source $HOME/.zshrc
  killall -USR1 termite
  i3-msg restart
}

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
  gh gist ${*:-view} ${GITHUB_GIST_TODOS:-`gh gist list | grep .todos | cut -f1`}
}

function emojis(){
  e=`emojify --list | sed '0,/Supported emojis/d' | sort | fzf --reverse`
  echo $e | cut -d" " -f1 | xclip -rmlastnl -selection primary
  echo $e | cut -d" " -f2 | xclip -rmlastnl -selection clipboard
}

alias song='playerctl metadata title | EDITOR="tee -a" gh gist edit `gh gist list | grep songs | cut -f1`'
alias songs='gh gist view `gh gist list | grep songs | cut -f1` -f songs'

function record(){
  FILENAME=${1:-/tmp/`date "+%Y%m%d_%H%M%S"`.mp4}
  ffmpeg -f x11grab -r 30 `hacksaw -f "-s %wx%h -i :0.0+%x,%y"` -q:v 0 -q:a 0 $FILENAME
  echo $FILENAME
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

function mirrorlist() {
  COUNTRIES=`echo ${*:-DE NL}| xargs -d" " -I{} echo -n "&country={}"`
  curl -s "https://archlinux.org/mirrorlist/?protocol=https&ip_version=4${COUNTRIES}" \
    | sed "s/#Server/Server/g" \
    | sudo tee /etc/pacman.d/mirrorlist
}


function remind(){
  if [ "$#" -eq 0 ]
  then
    rm -f /tmp/remind
    pkill -SIGRTMIN+4 i3blocks
    return
  fi

  TIME="$1"
  shift
  CONTENT="$*"

  echo "
    echo \"$CONTENT @ \`date\`\" > /tmp/remind
    pkill -SIGRTMIN+4 i3blocks
  " | at $TIME
}

function touchd(){
  mkdir -p `dirname "$1"` && touch "$1"
}

function wall(){
  sed -i "s|#`hostname` exec_always feh --no-fehbg --bg-fill \(https://unsplash.com/photos/.*\)/download?force=true|#`hostname` exec_always feh --no-fehbg --bg-fill $1/download?force=true|g" $HOME/.files/.config/i3/config
  source $HOME/.files/.zprofile
  i3-msg restart
}

function dockeron() {
  echo "{ \"auths\":{ \"ghcr.io\":{ \"auth\":\"`echo "$USER:$GITHUB_TOKEN" | base64`\"  }}}" > ${DOCKER_CONFIG:-$HOME/.docker/config.json}
}

function dockeroff() {
  rm -v ${DOCKER_CONFIG:-$HOME/.docker/config.json}
}

function awson(){
  export AWS_ACCESS_KEY_ID=`    pass ${PASSKEY:-seal/aws-teg-balazs4} | grep AWS_ACCESS_KEY_ID     | cut -d"=" -f2`
  export AWS_SECRET_ACCESS_KEY=`pass ${PASSKEY:-seal/aws-teg-balazs4} | grep AWS_SECRET_ACCESS_KEY | cut -d"=" -f2`
  export AWS_DEFAULT_REGION=`   pass ${PASSKEY:-seal/aws-teg-balazs4} | grep AWS_DEFAULT_REGION    | cut -d"=" -f2`
  export AWS_DEFAULT_OUTPUT=`   pass ${PASSKEY:-seal/aws-teg-balazs4} | grep AWS_DEFAULT_OUTPUT    | cut -d"=" -f2`
}

function awsoff(){
  export AWS_ACCESS_KEY_ID=
  export AWS_SECRET_ACCESS_KEY=
  export AWS_DEFAULT_REGION=
  export AWS_DEFAULT_OUTPUT=
}

function euro2020(){
  case "$1" in
    m4)
      curl -Ls 'https://onlinestream.live/?search=m4' \
        | pup 'a[href^="/play"] attr{href}' \
        | grep 5903 \
        | sed 's/amp;//g' \
        | xargs -I{} curl -Ls 'https://onlinestream.live{}' \
        | grep http \
        | grep -v xspf \
        | sed -r 's|<location>(.*)</location>|\1|g' 
      ;;

    ard)
      mpv 'https://mcdn.daserste.de/daserste/de/master.m3u8'
      ;;

    zdf)
      mpv 'http://zdf-hls-15.akamaized.net/hls/live/2016498/de/veryhigh/master.m3u8'
      ;;

  esac
}

# host-specific config

#vmware export N_PREFIX=$HOME/.n/prefix
#vmware export PATH=$HOME/.n/:$N_PREFIX/bin/:$HOME/.gem/ruby/2.7.0/bin:${PATH}
#vmware export RUBYOPT="-W0"  # ruby warnings
#vmware 
#vmware alias spotify='google-chrome-stable --app=https://open.spotify.com/' #webapp
#vmware alias youtube='google-chrome-stable https://youtube.com/' #webapp
#vmware alias whatsapp='chromium --app=https://web.whatsapp.com/' #webapp
#vmware alias p5="docker-compose --file $HOME/git/plossys-bundle/docker-compose.yml"
#vmware alias infra="GH_REPO=sealsystems/com-infrastructure gh"
#vmware alias outlook='chromium --app=https://outlook.office365.com/mail/inbox' #webapp
#vmware alias teams='chromium --app="https://teams.microsoft.com/_#/conversations/General?threadId=19:1e2f67587cad457580ed4b3908f67431@thread.tacv2&ctx=channel"' #webapp
#vmware alias slack='chromium --app="$SLACK_URL"' #webapp
#vmware alias mongodb-rs='docker run --rm -p "27017:27017" ghcr.io/sealsystems/mongodb-rs:4.4.4'
#vmware function checkin() {
#vmware   npm run --silent --prefix=$HOME/src/timesheet checkin `date -d "${*:-0 minutes ago}" -u "+%Y-%m-%dT%TZ"`
#vmware   git -C $HOME/src/timesheet commit -am '☕ checkin'
#vmware   git -C $HOME/src/timesheet push --no-verify
#vmware }
#vmware 
#vmware function checkout(){
#vmware   npm run --silent --prefix=$HOME/src/timesheet checkout `date -d "${*:-0 minutes ago}" -u "+%Y-%m-%dT%TZ"`
#vmware   git -C $HOME/src/timesheet commit -am '🍺 checkout'
#vmware   git -C $HOME/src/timesheet push --no-verify
#vmware }
#vmware 
#vmware function bcs() {
#vmware   npm run --silent --prefix=$HOME/src/timesheet start \
#vmware     | fx 'x => Object.entries(x).map(([day,duration]) => `${day}\t${duration}`).join("\n")' \
#vmware     | fzf --layout=reverse
#vmware }
#vmware 
#vmware function fa(){
#vmware   npm run --silent --prefix=$HOME/src/timesheet start \
#vmware     | fx 'x => Object.entries(x).map(([day,duration]) => `${day}\t${duration}`).join("\n")' \
#vmware     | sort \
#vmware     | tail -1 \
#vmware     | cut -f2
#vmware }
#vmware 
#vmware function jira-md(){
#vmware   curl -u "`pass seal/$JIRA_URL`" -is "https://$JIRA_URL/jira/rest/api/2/search?jql=key=$1" | alola | fx jira 
#vmware }
#vmware 
#vmware function jira(){
#vmware   jira-md $1 | glow -
#vmware }
#vmware 
#vmware function rapid(){
#vmware   curl -u "`pass seal/$JIRA_URL`" -is "https://$JIRA_URL/jira/rest/greenhopper/1.0/xboard/work/allData.json?rapidViewId=$1" | alola | fx rapid
#vmware }
#vmware 
#vmware function sprint(){
#vmware   rapid 131 | fzf -q "'${1:-bv}" --preview 'echo {} | cut -f1 | xargs -Iid zsh -c "source ~/.zshrc; jira id"' | cut -f1
#vmware }
#vmware 
#vmware function comment(){
#vmware   id=$1
#vmware   [[ -z "$id" ]] && return
#vmware   local txt; read txt; 
#vmware   [[ -z "$txt" ]] && return
#vmware   curl -u "`pass seal/$JIRA_URL`" -Lis "https://$JIRA_URL/jira/rest/api/2/issue/$id/comment" -H "Content-Type: application/json" -XPOST -d "{\"body\": \"$txt\" }" \
#vmware     -o /dev/null -w "%{http_code}"
#vmware   jira $id
#vmware }
#vmware 
#vmware function seal(){
#vmware   case "$1" in
#vmware     list)
#vmware       curl -H 'Cache-Control: no-cache' -s "https://$GITHUB_TOKEN@raw.githubusercontent.com/sealsystems/seal-parrot/master/betonieren.md" | sed 's/- //'
#vmware       ;;
#vmware     latest)
#vmware       curl -H 'Cache-Control: no-cache' -s "https://$GITHUB_TOKEN@raw.githubusercontent.com/sealsystems/seal-parrot/master/betonieren.md" | sed 's/- //' | tail -1 
#vmware       ;;
#vmware     *)
#vmware       curl -H 'Cache-Control: no-cache' -s "https://$GITHUB_TOKEN@raw.githubusercontent.com/sealsystems/seal-parrot/master/betonieren.md" | sed 's/- //' | shuf -n1 
#vmware       ;;
#vmware   esac
#vmware }
#vmware 
#vmware function q() {
#vmware   DOCKER_COMPOSE=`[[ -f $PWD/docker-compose.yml ]] && echo "$PWD/docker-compose.yml" || echo "$HOME/git/plossys-bundle/docker-compose.yml"`
#vmware   docker-compose --file "$DOCKER_COMPOSE" exec db mongo --ssl --sslAllowInvalidCertificates spooler-$1 --eval "db.$1.find($2)" \
#vmware     | sed '0,/server version/d'
#vmware }
#vmware 
#vmware function fixup(){
#vmware   npm run lint:fix || return 1
#vmware   git commit -a --fixup=HEAD
#vmware   git rebase -i origin --autosquash
#vmware   PAGER= git log --oneline -10
#vmware }

#carbon export NPM_CONFIG_PREFIX=$HOME/.npm_global
#carbon export PATH=$NPM_CONFIG_PREFIX/bin:$PATH
#carbon 
#carbon function yt(){
#carbon   [[ $# -eq 0 ]] && read stdin
#carbon   local search=`echo ${stdin:-*} | sed 's/\s/+/g'`
#carbon   curl -Lfs -H 'accept-language: en' "https://www.youtube.com/results?search_query=$search" \
#carbon     | pup 'script:contains("var ytInitialData") text{}' \
#carbon     | sed 's/var ytInitialData = //g;s/};/}/' \
#carbon     | fx youtubevideos \
#carbon     | fzf \
#carbon     | cut -f1 \
#carbon     | xargs -Iwatch mpv $MPV https://youtu.be/watch
#carbon }
#carbon alias yta="MPV='--no-video' yt"
alias blueon='sudo systemctl start bluetooth.service && bluetoothctl power on && bluetoothctl connect 17:50:01:B0:02:71 && pkill -SIGRTMIN+1 i3blocks'
alias blueoff='bluetoothctl power off && sudo systemctl start bluetooth.service && pkill -SIGRTMIN+1 i3blocks'
#carbon alias vercel='npx -q vercel -t $VERCEL_TOKEN'
#carbon alias vc='npx -q vercel -t $VERCEL_TOKEN'
#carbon alias now='npx -q vercel -t $VERCEL_TOKEN'
#carbon alias whatsapp='google-chrome-stable --user-data-dir=$HOME/.config/webapp/whatsapp --app=https://web.whatsapp.com'
#carbon alias outlook='microsoft-edge-dev --user-data-dir=$HOME/.config/webapp/microsoft --app=https://outlook.com'
#carbon alias spotify='google-chrome-stable --user-data-dir=$HOME/.config/webapp/spotify --app=https://open.spotify.com/'
#carbon alias shop='google-chrome-stable --user-data-dir=$HOME/.config/webapp/shop'
#carbon alias bank='google-chrome-stable --user-data-dir=$HOME/.config/webapp/bank'
#carbon alias google='google-chrome-stable --user-data-dir=$HOME/.config/webapp/google'
#carbon alias teams='microsoft-edge-dev --user-data-dir=$HOME/.config/webapp/microsoft365 https://teams.microsoft.com'

function helloworld() {
  curl \
    -H 'accept: application/json'\
    -H "private-token: $GITLAB_AUTH_TOKEN" \
    https://gitlab.com/api/v4/projects/balazs4%2Flebenslauf/issues/40/notes -Lisk \
    | npx -q alola \
    | npx -q fx  'x => x.body.map(xx => xx.body).join("\n")'
}
