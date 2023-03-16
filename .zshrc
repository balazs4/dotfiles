# Linux Darwin
HISTFILE=~/.zsh_history
HISTSIZE=100000
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
#mcbpro export HOMEBREW_PREFIX="/opt/homebrew";
#mcbpro export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
#mcbpro export HOMEBREW_REPOSITORY="/opt/homebrew";
#mcbpro export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
#mcbpro export PATH="/opt/homebrew/opt/curl/bin:$PATH"
#mcbpro export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
#mcbpro export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
#mcbpro FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
#mcbpro export PATH="$HOME/.luarocks/bin:${PATH}"
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

  git config --local --get user.email >/dev/null || \
    git config --local --get remote.origin.url \
      | awk '/gitlab.com/ {print "959395-balazs4@users.noreply.gitlab.com"}; /github.com/ {print "balazs4@users.noreply.github.com"}' \
      | xargs git config --local user.email

  git status --porcelain --branch --no-ahead-behind \
    | gawk '
      BEGIN                             { branch; staged=0;modified=0;untracked=0 }
      /^##/                             {sub(/\.\.\./," "); branch=$2; }
      /^##.*\[different\]$/             {branch=$4branch; }
      /^## No commits yet/              {branch="???";}
      /^(M|T|A|D|R|C|U) /               {staged++}
      /^ (M|T|A|D|R|C|U)/               {modified++}
      /^(M|T|A|D|R|C|U)(M|T|A|D|R|C|U)/ {staged++; modified++}
      /^\?\?/                           {untracked++}
      END                               { print " [ %F{white}" branch "%f«%B%F{green}" staged "%f%b«%B%F{red}" modified "%f%b«%B%F{red}" untracked "%f%b ]"}' \
    | sed 's|%B%F{green}0%f%b|0|g;s|%B%F{red}0%f%b|0|g;s|%F{white}\[different\]|%B%F{red}! %f%b%F{white}|g'
}

setopt PROMPT_SUBST

function zle-line-init zle-keymap-select {
  PROMPT='%B%F{white} %~%f%b$(zsh-git &) %B%F{white}»%f%b '
  RPROMPT="%(?.%F{white}.%F{red})%?%f `[[ $KEYMAP == 'vicmd' ]] && echo '[normal]'`"
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1

function zz() {
  local to=`{
    echo $HOME/.files;
    find $HOME/src -maxdepth 1 -type d;
    find /tmp -maxdepth 1 -type d;
  } | fzf --layout=reverse --height '40%' -q "'${*:-$PWD} " -1`

  [[ $TMUX ]] \
    && cd ${to:-$PWD} \
    || tmux new-session -A -s ${to:-$PWD} -c ${to:-$PWD}
}

alias z='TMUX=fake zz'

#carbon source /usr/share/fzf/completion.zsh
#carbon source /usr/share/fzf/key-bindings.zsh
#mcbpro source /opt/homebrew/opt/fzf/shell/completion.zsh
#mcbpro source /opt/homebrew/opt/fzf/shell/key-bindings.zsh

export LANG=en_US.UTF-8
export TERMINAL=alacritty
export TERM=xterm-256color
#mcbpro export BROWSER=open
#carbon export BROWSER=chromium
export EDITOR=vim
export FZF_DEFAULT_COMMAND="fd --hidden --type=f -E node_modules -E .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
#mcbpro export FZF_DEFAULT_OPTS="--no-separator --bind 'ctrl-x:execute-silent(echo {} | xurls | xargs open)'"
#carbon export FZF_DEFAULT_OPTS="--no-separator --bind 'ctrl-x:execute-silent(echo {} | xurls | xargs xdg-open)'"
export GPG_TTY=`tty`
export RIPGREP_CONFIG_PATH=$HOME/.rgrc
export PATH=$HOME/.local/bin:${PATH}

#nodejs
export NPM_CONFIG_LOGLEVEL=http
export DOTENV_CONFIG_DEBUG=true
export N_PREFIX=$HOME/.n/prefix
export N_PRESERVE_NPM=1
export PATH=$HOME/.n/:$N_PREFIX/bin/:${PATH}
export PATH=./node_modules/.bin/:${PATH}

#go
export GOPATH=$HOME/.go
export PATH=${GOPATH}/bin:${PATH}

#rust
export PATH=$HOME/.cargo/bin:$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/:${PATH}


function dot(){
  pushd $HOME/.files > /dev/null
    $EDITOR ${1:-.}
    TMUX= source $PWD/.zprofile
  popd > /dev/null
}

function dotsync(){
  git -C $HOME/.files commit -am "`date +%s`@`hostname -s`"
  git -C $HOME/.files pull
  git -C $HOME/.files push
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
    TMUX= source $HOME/.files/.zprofile
  fi

  rm -rf $HOME/.vim/pack/_/start/* 2>/dev/null
  mkdir -p $HOME/.vim/pack/_/start/ 2>/dev/null
  pushd $HOME/.vim/pack/_/start/
  grep '^"https://github' $HOME/.vimrc | sed 's/"//g' | xargs -t -L1 git clone --depth=1
  popd
}

function nvimplug(){
  if [[ ! -z "$1" ]]
  then
    echo "\n-- $1" >> $HOME/.files/.config/nvim/init.lua
    TMUX= source $HOME/.files/.zprofile
    git -C $HOME/.local/share/nvim/site/pack/_/start/ clone --depth=1 $1
    return
  fi

  rm -rf $HOME/.local/share/nvim/site/pack/_/start/* 2>/dev/null
  mkdir -p $HOME/.local/share/nvim/site/pack/_/start/ 2>/dev/null

  pushd $HOME/.local/share/nvim/site/pack/_/start/
    grep '^-- https://github' $HOME/.config/nvim/init.lua | sed 's/-- //g' | xargs -t -L1 git clone --depth=1
  popd
}

alias so="source $HOME/.zshenv"
alias v="vim -c ':GFiles?'"
alias zshrc="dot .zshrc; source $HOME/.zshrc"
alias vimrc="dot .vimrc"
alias nvimrc="EDITOR=nvim dot .config/nvim/init.lua"
#carbon alias sx="dot .config/sxhkd/sxhkdrc; killall -USR1 sxhkd"
alias wttr="curl -H 'cache-control: no-cache' -s 'http://wttr.in/91085?format=3'"
#carbon alias xx='xclip -rmlastnl -selection clipboard'
#mcbpro alias xx='pbcopy'
alias ls='ls --color=auto'
alias grep='grep --color'
alias tree='fd | tree --fromfile'
alias :q='exit'
alias :q!='exit'
alias ll='ls -lsh'
alias rm='rm -i'
alias bob="node -p \"process.argv.slice(1).map(w => w.split('').map(c=>Math.random()>0.5?c.toUpperCase():c.toLowerCase()).join('')).join(' ')\""
alias yolo='git add . && git commit -m "`bob yolo commit` :sponge:" --no-verify && git push --no-verify || true'
alias foo='echo bar'
alias http="node -p \"Object.entries(require('http').STATUS_CODES).map(x=> x.join('\t')).join('\n')\" | fzf --sync"
alias mc='mc -b'
alias ssh='TERM=xterm-256color ssh'
alias scpignore="scp -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null"
alias sshignore="ssh -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null"
alias gd='git diff'
alias gst='git status'
alias gco='git checkout'
alias gpp='git pull --prune --tags'
alias gcm='git checkout `git branch | grep -m 1 -E "^\s+(canary|main|master)$" | sed "s|^* ||g"`'
alias gf="git status --porcelain | awk '{print \$NF}'"
alias shrug='curl -s http://shrug.io | xx'
alias wipe='docker rm -f `docker ps -aq`; docker network prune -f; docker volume prune -f'
#carbon alias dco='docker compose'
#mcbpro alias dco='docker-compose'
alias rg='rg --hidden'
alias dmesg='sudo dmesg'
alias cal='LC_ALL=de_DE.utf8 cal'
#carbon alias yay='yay --editmenu'
#mcbpro alias awk='gawk'
#mcbpro alias sed='gsed'
#mcbpro alias xargs='gxargs'
alias less='less -r'
alias delta='delta --side-by-side --syntax-theme=Nord'

function srv(){
  node -e "
  require('http').createServer(async (req, res) => {
    process.stdout.write('\n');
    process.stdout.write(req.method + ' ' + req.url);
    process.stdout.write('\n');
    Object.entries(req.headers).forEach(([key, value]) => {
      process.stdout.write(key + ': ' + value);
      process.stdout.write('\n');
    });
    process.stdout.write('\n');
    res.writeHead(200, { 'content-type': 'text/plain' });
    res.end();
  }).listen(${PORT:-8000}, () => console.log('http://localhost:${PORT:-8000}'));
  "
}

function cheat(){
  curl -Lis cht.sh${*} | less -r
}

function radio(){
  term=$(echo $* | tr ' ' '+')
  curl http://opml.radiotime.com/Search.ashx\?query\=$term -s \
    | fxparser \
    | fx 'xx => xx.opml.body.outline.filter(x => x["@_item"] === "station").map(x=>[ x["@_URL"], x["@_reliability"], x["@_text"], x["@_subtext"] ].join("\t")).join("\n")' \
    | fzf --sync --reverse --height=50% \
    | cut -f1 \
    | mpv --playlist=-
}

function dw(){
  local url="https://de.wiktionary.org/wiki/$1"
  local content=`curl -s "$url"`
  echo "$content" | pup 'table.wikitable' | w3m -dump -T text/html | sed '/^$/d'
  echo "$content" | pup 'table[title~="andere Sprachen"]' | w3m -dump -T text/html | grep Englisch | sort | uniq | sed '/^$/d'
  echo $url
}

function wiki(){
  url="https://en.wikipedia.org/wiki/`echo $* | sed 's/\s/+/g'`"
  reader -o "$url" | glow -p -
  echo $url
}

function todos(){
  gh gist ${*:-view} ${GITHUB_GIST_TODOS}
}

function browse(){
  reader -o "$*" | glow -p -
}

#carbon function emojis(){
#carbon   emojify --list \
#carbon     | sed '0,/Supported emojis/d' \
#carbon     | sort \
#carbon     | fzf --reverse \
#carbon     | awk '{print $1 | "xclip -rmlastnl -selection primary" }; {print $2 | "xclip -rmlastnl -selection clipboard" }'
#carbon }

#carbon alias song='playerctl metadata title | EDITOR="tee -a" gh gist edit $GITHUB_GIST_SONGS'
#carbon alias songs='gh gist view $GITHUB_GIST_SONGS -f songs'

#carbon function record(){
#carbon   FILENAME=${1:-/tmp/`date "+%Y%m%d_%H%M%S"`.mp4}
#carbon   ffmpeg -f x11grab -r 30 `hacksaw -f "-s %wx%h -i :0.0+%x,%y"` -q:v 0 -q:a 0 $FILENAME
#carbon   echo $FILENAME
#carbon }

function co(){
  for handle in "$@"; do echo "Co-authored-by: $handle <$handle@users.noreply.github.com>"; done
}

#carbon function mirrorlist() {
#carbon   COUNTRIES=`echo ${*:-DE NL}| xargs -d" " -I{} echo -n "&country={}"`
#carbon   curl -s "https://archlinux.org/mirrorlist/?protocol=https&ip_version=4${COUNTRIES}" \
#carbon     | sed "s/#Server/Server/g" \
#carbon     | sudo tee /etc/pacman.d/mirrorlist
#carbon }


#carbon function remind(){
#carbon   if [ "$#" -eq 0 ]
#carbon   then
#carbon     rm -f /tmp/remind
#carbon     pkill -SIGRTMIN+4 i3blocks
#carbon     return
#carbon   fi
#carbon 
#carbon   TIME="$1"
#carbon   shift
#carbon   CONTENT="$*"
#carbon 
#carbon   echo "
#carbon     echo '$CONTENT' > /tmp/remind
#carbon     pkill -SIGRTMIN+4 i3blocks
#carbon     dunstify \"\`date\`\" '$CONTENT'
#carbon   " | at $TIME
#carbon }

function touchd(){
  mkdir -p `dirname "$1"` && touch "$1"
}

function wall(){
  sed -i "s|#`hostname` exec_always feh --no-fehbg --bg-fill \(https://unsplash.com/photos/.*\)/download?force=true|#`hostname` exec_always feh --no-fehbg --bg-fill $1/download?force=true|g" $HOME/.files/.config/i3/config
  source $HOME/.files/.zprofile
  i3-msg restart
}

function ghcrio-on() {
  echo "{ \"auths\":{ \"ghcr.io\":{ \"auth\":\"`echo "$USER:$GITHUB_TOKEN" | base64`\"  }}}" > ${DOCKER_CONFIG:-$HOME/.docker/config.json}
}

function ghcrio-off() {
  rm -v ${DOCKER_CONFIG:-$HOME/.docker/config.json}
}

function aws-on(){
  export `pass ${PASSKEY:-aws/balazs4} | awk '/^AWS_/ {print $0}'`
}

function aws-off(){
  unset `env | awk -F= '/^AWS_/ {print $1 }'`
}

function yt(){
  echo $* \
    | tr ' ' '+' \
    | xargs -t -I{} curl -Lfs -H 'accept-language: en' https://www.youtube.com/results\?search_query={} \
    | pup 'script:contains("var ytInitialData") text{}' \
    | sed 's/var ytInitialData = //g; s/};/}/' \
    | fx youtubevideos \
    | sort -k3 -rh \
    | fzf --sync --reverse --height=50% \
    | cut -f1 \
    | xargs -Iwatch mpv ${MPV:---ytdl-format='[height=1080]/best'} https://youtu.be/watch
}
alias yta="MPV='--no-video' yt"

function blue() {
  if [[ "$1" == "off" ]]
  then
    bluetoothctl power off
    sudo systemctl stop bluetooth.service
  else
    sudo systemctl start bluetooth.service
    sleep 2s
    bluetoothctl power on
    sleep 2s
    device=`bluetoothctl devices | fzf -1 -q ${1:-""} | cut -d" " -f2`
    bluetoothctl connect $device
  fi
  pkill -SIGRTMIN+1 i3blocks
}

#carbon alias whatsapp='google-chrome-stable --user-data-dir=$HOME/.config/webapp/whatsapp --app=https://web.whatsapp.com'
#carbon alias telegram='google-chrome-stable --user-data-dir=$HOME/.config/webapp/telegram --app=https://web.telegram.org'
#carbon alias outlook='microsoft-edge-dev --user-data-dir=$HOME/.config/webapp/microsoft --app=https://outlook.com'
#carbon alias spotify='google-chrome-stable --user-data-dir=$HOME/.config/webapp/spotify --app=https://open.spotify.com/'
#carbon alias shop='google-chrome-stable --user-data-dir=$HOME/.config/webapp/shop'
#carbon alias bank='google-chrome-stable --user-data-dir=$HOME/.config/webapp/bank'
#carbon alias google='google-chrome-stable --user-data-dir=$HOME/.config/webapp/google'

function pihole(){
  curl -Lis http://192.168.178.42/admin/api.php \
    | npx alola 'status should be 200' 'headers.x-pi-hole should be The Pi-hole Web interface is working!' 1>/dev/null
}

#carbon function helloworld(){
#carbon   curl -H 'accept: application/json' -H "private-token: $GITLAB_TOKEN" "$GITLAB_HELLOWORLD_URL/issues?state=opened&confidential=true" -Lis \
#carbon     | npx alola \
#carbon     | npx fx .body 'x => x.map(xx => [xx.iid, xx.web_url, xx.created_at, xx.user_notes_count, xx.title].join("\t") ).join("\n")' \
#carbon     | fzf --preview-window='down,75%' --preview "echo {} | cut -f1 | xargs -Iid curl -H 'accept: application/json' -H 'private-token: $GITLAB_TOKEN' \"$GITLAB_HELLOWORLD_URL/issues/id/notes\" -Lisk | npx alola | npx fx 'x => x.body.map(xx => xx.body).join(\"\n\")'"
#carbon }


function qrdecode {
  shotgun `hacksaw -f "-i %i -g %g"` - | zbarimg -q --raw -
}

function wallomat {
  # wallomat 6D-A6CL3Pv8 24
  mpv "https://www.youtube.com/watch?v=$1&t=$2" --no-audio --frames=1 -o /tmp/mpv.png
  feh --no-fehbg --bg-fill /tmp/mpv.png
}

function public() {
  DOCKER_COMPOSE=tmp-docker-compose.yml
  echo "
services:
  tunnel:
    image: node:alpine
    tty: true
    entrypoint: /bin/sh
    command:
      - -c
      - |
        npx -y localtunnel --port 80 --local-host server --print-requests
    environment:
      NPM_CONFIG_LOGLEVEL: error
  server:
    image: nginx:alpine
    volumes:
`fd --type f | xargs -I{} echo "      - './{}:/usr/share/nginx/html/{}:ro'"`" \
  | vipe --suffix .yml > $DOCKER_COMPOSE

  docker compose -f $DOCKER_COMPOSE up
  rm -f $DOCKER_COMPOSE
}

#carbon function now(){
#carbon   local artUrl=`playerctl metadata --format '{{mpris:artUrl}}'`
#carbon   local title="`playerctl metadata --format '{{title}}'`"
#carbon   local artist="`playerctl metadata --format '{{artist}}'`"
#carbon   local searchterm=`node -p "encodeURIComponent('$artist $title'.trim())"`
#carbon 
#carbon   [[ $artUrl ]] && curl -s $artUrl -o /tmp/$searchterm.png
#carbon 
#carbon   if [[ ! -f /tmp/$searchterm.png ]]
#carbon   then
#carbon     curl -Lisk "https://api.deezer.com/search?strict=on&q=$searchterm" \
#carbon       | ALOLA_REPORT=silent npx alola 'status should be 200' \
#carbon       | npx fx 'x => x.body.data.map(xx => xx.album.cover_medium).join("\n")' \
#carbon       | head -1 \
#carbon       | xargs -I{} curl -s {} -o /tmp/$searchterm.png
#carbon   fi
#carbon 
#carbon   dunstify -I /tmp/$searchterm.png "$title" "$artist"
#carbon }

function news(){
  tmux new-session -s 'news' -d

  tmux rename-window -t "news.1" "wttr"
  tmux send-keys -t "news:wttr.1" "curl -s http://wttr.in/91085" Enter

  tmux new-window -t "news" -n "hackernews"
  tmux send-keys -t "news:hackernews.1" "hackernews 10" Enter

  for subreddit in `echo commandline javascript | xargs`
  do
    tmux new-window -t "news" -n "r/$subreddit"
    tmux send-keys -t "news:r/$subreddit.1" "reddit $subreddit" Enter
  done

#carbon  tmux new-window -t "news" -n "archnews"
#carbon  tmux send-keys -t "news:archnews.1" "archnews" Enter

  tmux attach-session -t 'news'
}

function hackernews(){
  curl -Lis https://hacker-news.firebaseio.com/v0/topstories.json \
    | alola 'status should be 200' 2>/dev/null \
    | fx "x=> x.body.slice(0,${1:-10}).join(\"\n\")" \
    | xargs -I{} curl -s https://hacker-news.firebaseio.com/v0/item/{}.json \
    | fx 'x => [`\x1b[2m${x.url}\x1b[0m`, `\x1b[1m${x.title}\x1b[0m`, " "].join("\n")' 
}

function reddit(){
  curl -H 'cache-control: no-cache' -Ls --user-agent "$RANDOM" "https://www.reddit.com/r/${1:-all}/hot.json"\
    | fx 'x => x.data.children.slice(10).map(xx => [`\x1b[2m${xx.data.url}\x1b[0m`, `\x1b[1m${xx.data.title}\x1b[0m (${xx.data.subreddit_name_prefixed})`, " "].join("\n")).join("\n")'
}

function archnews(){
  curl -s https://archlinux.org/feeds/news/ \
    | fxparser \
    | fx 'x => x.rss.channel.item.map(xx => [`\x1b[2m${xx.link}\x1b[0m`, new Date(xx.pubDate).toJSON() + ` >> \x1b[1m${xx.title}\x1b[0m`, " "].join("\n")).join("\n")'
}

#carbon alias screensaver='tmux new-session -s xcowsay -d "while true; do xcowsay catch me if you can; done";exit'

function mongodb-rs(){
  docker ps -a | grep 27017 | cut -f1 -d" " | xargs -tr docker kill
  mongo_container_id=`docker run -d --rm -p "27017:27017" mongo:${1:-4.4.4} --replSet rs` 
  docker exec -i $mongo_container_id sh -c '
    while ! mongo  --eval "db.version()" >/dev/null; do sleep 0.5s; done; \
    mongo --eval "rs.initiate()"; \
    while ! mongo  --eval "rs.status().members[0].stateStr" | grep PRIMARY; do sleep 0.5s; done; \
    mongo --eval "db.createCollection(\"test\")"
  '
  docker ps -a | grep 27017 
}


#carbon function desk-on(){
#carbon   xrandr \
#carbon     --dpi 136 \
#carbon     --output eDP1 --primary --mode 1920x1080 --pos 800x2160 --rotate normal --scale 1.4 \
#carbon     --output DP1 --off \
#carbon     --output DP2 --mode 3840x2160 --pos 0x0 --rotate normal
#carbon 
#carbon    echo "Xft.dpi: 136" | xrdb -merge
#carbon    i3-msg restart
#carbon    imwheel >/dev/null &
#carbon }
#carbon 
#carbon function desk-off(){
#carbon   xrandr \
#carbon     --dpi 96 \
#carbon     --output eDP1 --primary --mode 1920x1080 --rotate normal --scale 1.0 \
#carbon     --output DP1 --off \
#carbon     --output DP2 --off 
#carbon 
#carbon    echo "Xft.dpi: 96" | xrdb -merge
#carbon    i3-msg restart
#carbon    killall -9 imwheel >/dev/null
#carbon }


#carbon function record-tmux(){
#carbon   local cast="/tmp/tmux-$1.json"
#carbon   asciinema rec --command "tmux attach -t $1" $cast
#carbon   #npx -yq -p svg-term-cli
#carbon   svg-term --in $cast --out $cast.svg
#carbon   ls -lsh $cast*
#carbon }
#carbon 
#carbon function typo(){
#carbon   local target=$1
#carbon   shift
#carbon   node -p 'process.argv.slice(1).map(x => x.split("").map(xx => xx + "\n").join("")).join("\n").trim()' ${*} \
#carbon     | xargs -I% -d '\n' -n1 sh -c "tmux send-keys -t '$target' '%'; sleep 0.1s;"
#carbon 
#carbon   sleep 0.2s
#carbon   tmux send-keys -t "$target" Enter
#carbon }
#carbon 
#carbon test -f $HOME/.nix-profile/etc/profile.d/nix.sh && source $HOME/.nix-profile/etc/profile.d/nix.sh
#carbon 
#carbon function raw(){
#carbon   curl -Ls "$1?raw=true"
#carbon }
#carbon 
#carbon function yayfzf(){
#carbon   yay -Sy
#carbon   yay -Slq | fzf --preview 'yay -Si {1}' --query "'${1}" -1 | xargs yay -Sy --noconfirm 
#carbon   hash -r
#carbon }
#carbon alias yf=yayfzf
#carbon alias yzf=yayfzf
#carbon alias yayf=yayfzf

function gitlab-pipeline(){
  local project=`git config --get remote.origin.url | awk -F: '{ sub(/\.git$/,""); sub(/\//,"%2F");  print $2}'`
  local sha=`git rev-parse HEAD`
  local ref=`git rev-parse --abbrev-ref HEAD`

  curl -Ls -H "private-token: $GITLAB_AUTH_TOKEN" "https://gitlab.com/api/v4/projects/$project/pipelines/?sha=$sha&ref=$ref" \
    | xurls \
    | xargs xdg-open
}

function gb(){
  git branch -a \
    | grep -v HEAD \
    | fzf -1 -q "'${*}" \
    | sed 's|remotes/origin/||g;s|^*||g' \
    | xargs -t git checkout
}

alias .env='set -o allexport; source .env; set +o allexport'

alias flip='rev | perl -Mopen=locale -Mutf8 -pe tr/a-z/ɐqɔpǝɟƃɥıɾʞlɯuodᕹɹsʇnʌʍxʎz/'

alias src='fx package.json .scripts'

#mcbpro export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
#mcbpro export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"
#mcbpro export BUILD_LIBRDKAFKA=0

function light(){
#carbon  xbacklight \=100
  curl -Ls https://raw.githubusercontent.com/aarowill/base16-alacritty/914727e48ebf3eab1574e23ca0db0ecd0e5fe9d0/colors/base16-github.yml >> $HOME/.alacritty.yml

  echo "set background=light" >> $HOME/.vimrc
  echo "color shine" >> $HOME/.vimrc

  echo '--theme="gruvbox-light"' >> $HOME/.config/bat/config
}

function dark(){
  source $HOME/.files/.zprofile &> /dev/null
#carbon  xbacklight \=20
}

#carbon function cool(){
#carbon   echo level ${1:-7} | sudo tee /proc/acpi/ibm/fan
#carbon }

#mcbpro function feedback() {
#mcbpro   npm run test -- --watch `fzf -m -1 --query="'.test.ts !snap '$*"`
#mcbpro }
#mcbpro
#mcbpro function fmt(){
#mcbpro   git status --porcelain | awk '{print $NF}' | xargs -t npx prettier --ignore-unknown --write
#mcbpro }
#mcbpro function lint(){
#mcbpro   { git status --porcelain | awk '{print $NF}'; } | grep '\.ts' | sort | uniq | xargs -t npx eslint --fix --max-warnings=0 --no-error-on-unmatched-pattern
#mcbpro }
#mcbpro
#mcbpro function transpile() {
#mcbpro   npx tsc --noEmit --watch --project `fzf -1 --query="'tsconfig.json $*"`
#mcbpro }
#mcbpro alias annoyme=transpile
function ff(){
  { git status --porcelain | awk '{print $NF}'; gh pr diff --patch | grep '^+++ b' | sed 's/+++ b\///' 2>/dev/null } | sort | uniq
}

function meme(){
  local auth=`pass imgflip.com | grep username`
  local meme=`curl -Lisk https://api.imgflip.com/get_memes | alola 'status should be 200' 'body.success should be true' 2>/dev/null | fx 'x => x.body.data.memes.map(xx => [xx.id.padEnd(8), xx.url.padEnd(32), xx.box_count, xx.name].join("\t")).join("\n")' | fzf -1 --query "'$1" | cut -f1`

  shift;
  local text=`node -p 'new URLSearchParams(process.argv.slice(1).map((x,i)=> (["text"+i,x]))).toString()' $*`

  curl -Lisk https://api.imgflip.com/caption_image -d "$auth&template_id=$meme&$text" \
    | alola \
      'status should be 200' \
      'body.success should be true' 2>/dev/null\
    | fx 'x => x.body.data.url' \
    | xargs -I{} curl -Lsk {} --output - \
    | xclip -selection clipboard -t 'image/png'
}

alias cmm='meme 129242436'

#mcbpro function linear(){
#mcbpro   jo query="$*" \
#mcbpro     | curl -Lis -H 'content-type: application/json' -H "authorization: Bearer $LINEAR_TOKEN" https://api.linear.app/graphql -XPOST -d@- \
#mcbpro     | alola 'status should be 200' 2>/dev/null \
#mcbpro     | fx 'x => x.body.data'
#mcbpro }
#mcbpro 
#mcbpro function issues(){
#mcbpro   if test -z $LINEAR_USER_ID
#mcbpro   then
#mcbpro     export LINEAR_USER_ID=`linear '{viewer{id}}' | fx .viewer.id`
#mcbpro   fi
#mcbpro   linear "{user(id: \"$LINEAR_USER_ID\") {assignedIssues(filter: {state: {name: {nin: [\"Done\", \"Canceled\"]}}}){nodes {url identifier state {name}}}}}" \
#mcbpro     | fx 'x => x.user.assignedIssues.nodes.map(xx => [ xx.url, xx.identifier, xx.state.name].join("\t")).join("\n")' \
#mcbpro     | fzf -1 -q "'$*"
#mcbpro }
#mcbpro function lfg(){
#mcbpro   issues $* | cut -f2 | gawk '{print tolower($0)}' | xargs git checkout -b
#mcbpro }

function s3fzf(){
  aws s3 ls ${1} --recursive \
    | fzf --preview "aws s3 cp ${1}{4} -" \
    | awk '{print $NF}' \
    | xargs -I{} aws s3 cp ${1}{} -
}


function vvv(){
  latest_release=`gh release list -L1 | cut -f1`
  if test -z $latest_release
  then
    npm version --no-git-tag-version 1.0.0
    return 0
  fi

  git log --oneline --all $latest_release...HEAD \
    gawk '
      BEGIN                   { major=0;minor=0;patch=0 }
      /^[0-9a-z]{7} breaking/ { major++ }
      /^[0-9a-z]{7} major/    { major++ }
      /^[0-9a-z]{7} minor/    { minor++ }
      /^[0-9a-z]{7} patch/    { patch++ }
    END                   { if (major > 0) print "major"; else if (minor>0) print "minor"; else if (patch > 0) print "patch"; else print "noop"}' \
    | xargs -t npm version --no-git-tag-version
}


function tv(){
  curl -Ls "https://onlinestream.live/?search=$1" \
    | pup 'a[href^="/play.m3u8"] attr{href}' \
    | sed 's/amp;//g'  \
    | xargs -I{} curl -Ls https://onlinestream.live{} \
    | xurls \
    | fzf -1 -q "https://streaming.mytvback.com/stream" \
    | xargs mpv
}

function jwt(){
  node -e "
  (async() => {
    for await (const line of require('readline').createInterface(process.stdin)) {
      const [header, payload, signature] = line.split('.').map(x => Buffer.from(x, 'base64').toString());
      const jwt = {header:JSON.parse(header), payload: JSON.parse(payload)};
      console.log(jwt);
    }
  })();
  "
}

function ip() {
  dig $1 | awk "/^$1/ {print \$NF}"
}

#mcbpro function bypass() {
#mcbpro   set -o pipefail
#mcbpro   echo $* \
#mcbpro     | xargs -t curl -Lisf -c /dev/null --resolve ${RESOLVER:-'nothing:443:127.0.0.1'} \
#mcbpro     | alola 'redirects.0.headers.set-cookie should match _jwt' 'status should be 200' \
#mcbpro     | fx jwt \
#mcbpro     | jwt
#mcbpro }

#mcbpro function cosmos() {
#mcbpro   echo $CSMS_CONTAINERS \
#mcbpro     | tr ' ' '\n' \
#mcbpro     | fzf --reverse --height=50% -1 -q "'$1"\
#mcbpro     | xargs -I{} curl -H "Authorization: Bearer $VC_TOKEN" -Ls  "$CSMS_TOKEN" -XPOST -H 'content-type: application/json' -d '{ "containers": ["{}"], "type": "read" }' \
#mcbpro     | fx 'x => x.map(xx => xx.connectionString).join("\n")' \
#mcbpro     | pbcopy
#mcbpro     docker run --rm -it fathyb/carbonyl https://cosmos.azure.com
#mcbpro }

function va(){
  local api=${1}
  shift
  curl --http1.1 -sLfS -H "$VC_BACKOFFICE_AUTH" "$VC_BACKOFFICE${api}" ${*}
}

function contrib(){
  {
    gh api --paginate "/search/issues?per_page=100&q=org:$GITHUB_ORG+sort:created+created:>$GITHUB_START+involves:@me+is:pr";
    gh api --paginate "/search/issues?per_page=100&q=org:$GITHUB_ORG+sort:created+created:>$GITHUB_START+involves:@me+is:issue";
    gh api /gists/`echo $GITHUB_GIST_BRAG | awk -F/ '{print $NF}'` | fx 'x => x.files["brag.json"].content';
  } \
    | fx 'x => x.items.map(xx => [xx.created_at, xx.html_url.padEnd(64), "+" + xx.reactions["heart"], [xx.user.login, xx.assignee?.login].some(xxx => xxx === "balazs4") ? "balazs4" : "contrib" , "»»" , xx.title].join("\t")).join("\n")' \
    | sort -h \
    | uniq
}

function countby(){
   awk '{a[$1]++;} END{for(i in a) print i"  "a[i]}' | sort -k2 -r -h
}

function brag(){
  z `echo $GITHUB_GIST_BRAG | awk -F/ '{print $NF}'`

  local url=$1
  shift

  node -e "
  const brag = require('./brag.json');
  brag.items.push({ created_at: new Date().toJSON(), html_url: '$url', title: '$*', reactions: { 'heart': '1' }, user: { login: '$USER' } });
  require('fs').writeFileSync('./brag.json', JSON.stringify(brag));
  "
  npx prettier --write ./brag.json \
    && PAGER= git diff \
    && git commit -am "date +%s" \
    && git push \
    && cd -
}

alias carbonyl='docker run --rm -it fathyb/carbonyl'

function home(){
  echo "There is no place like home"
  tmux new-session -A -s $HOME -c $HOME
}
