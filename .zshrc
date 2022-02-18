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

  if [[ `git worktree list | grep '(bare)' | awk '{print $1}'` == ${PWD} ]]
  then
    git worktree list | awk '{print $NF}' | xargs
    return
  fi

  git status --porcelain --branch --no-ahead-behind \
    | awk '
      BEGIN { branch; staged=0;modified=0;untracked=0 }
      /^##/             {sub(/\.\.\./," "); branch=$4$2 }
      /^(M|T|A|D|R|C) / {staged++}
      /^ (M|T|A|D|R|C)/ {modified++}
      /^(M|T|A|D|R|C)(M|T|A|D|R|C)/ {staged++; modified++}
      /^\?\?/           {untracked++}
      END { print " [ %F{white}" branch "%f«%B%F{green}" staged "%f%b«%B%F{red}" modified "%f%b«%B%F{red}" untracked "%f%b ]"}' \
    | sed 's|%B%F{green}0%f%b|0|g;s|%B%F{red}0%f%b|0|g;s|%F{white}\[different\]|%B%F{red}! %f%b%F{white}|g'
}

setopt PROMPT_SUBST

function zle-line-init zle-keymap-select {
  PROMPT='%B%F{white} ▲ %~%f%b$(zsh-git &) %B%F{white}»%f%b '
  RPROMPT="%(?.%F{white}.%F{red})%?%f `[[ $KEYMAP == 'vicmd' ]] && echo '[normal]'`"
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1

function zz() {
  local to=`{
    echo $HOME/.files;
#carbon    fd --full-path $HOME/src --type d --max-depth=1 --absolute-path $HOME/src --hidden;
#vmware    fd --full-path $HOME/git --type d --max-depth=1 --absolute-path $HOME/git --hidden;
    fd --full-path /tmp --type d --max-depth=1 --absolute-path /tmp;
  } | fzf --layout=reverse --height '40%' -q "'${*:-$PWD} " -1`

  [[ ! -z $to ]] && cd $to

  [[ $TMUX ]] || tmux new-session -A -s `basename $PWD`
}

alias z='TMUX=fake zz'

[[ -r "/usr/share/fzf/completion.zsh" ]] && source /usr/share/fzf/completion.zsh
[[ -r "/usr/share/fzf/key-bindings.zsh" ]] && source /usr/share/fzf/key-bindings.zsh

export LANG=en_US.UTF-8
export TERMINAL=alacritty
export TERM=xterm-256color
export BROWSER=chromium
export EDITOR=vim
export NPM_CONFIG_LOGLEVEL=http
export FZF_DEFAULT_COMMAND="fd --hidden --type=f -E node_modules -E .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export GPG_TTY=`tty`
export GOPATH=$HOME/.go
export RIPGREP_CONFIG_PATH=$HOME/.rgrc

function dot(){
  pushd $HOME/.files > /dev/null
    [[ $1 ]] && vim $1 || vim -c ':GFiles'
    source $PWD/.zprofile
  popd > /dev/null
}

function dotsync(){
  git -C $HOME/.files commit -am "`date +%s`@`hostname`"
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
    source $HOME/.files/.zprofile
  fi

  rm -rf $HOME/.vim/pack/_/opt/*
  pushd $HOME/.vim/pack/_/opt/
  grep github $HOME/.vimrc | sed 's/"//g' | xargs -t -L1 git clone --depth 1
  popd
}

alias v="vim -c ':GFiles'"
alias zshrc="dot .zshrc; source $HOME/.zshrc"
alias vimrc="dot .vimrc"
alias sx="dot .config/sxhkd/sxhkdrc; killall -USR1 sxhkd"
alias wttr="curl -s 'http://wttr.in/91085?format=3'"
alias xx='xclip -rmlastnl -selection clipboard'
alias ls='ls --color=auto'
alias grep='grep --color'
alias tree='tree -I node_modules'
alias :q='exit'
alias :q!='exit'
alias ll='ls -lsh'
alias rm='rm -i'
alias bob="node -p \"process.argv.slice(1).map(w => w.split('').map(c=>Math.random()>0.5?c.toUpperCase():c.toLowerCase()).join('')).join(' ')\""
alias yolo='git add . && git commit -m "`bob yolo commit` :sponge:" && git push --no-verify || true'
alias foo='echo bar'
alias http="node -p \"Object.entries(require('http').STATUS_CODES).map(x=> x.join('\t')).join('\n')\" | fzf"
alias mc='mc -b'
alias ssh='TERM=xterm-256color ssh'
alias scpignore="scp -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null"
alias sshignore="ssh -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null"
alias gd='git diff'
alias gst='git status'
alias gco='git checkout'
alias gpp='git pull --prune --tags'
alias gcm='git checkout `git branch | grep -P "(canary|main|master)"`'
alias shrug='curl -s http://shrug.io | xx'
alias wipe='docker rm -f `docker ps -aq`; docker network prune -f; docker volume prune -f'
alias dco='docker compose'
alias rg='rg --hidden'
alias dmesg='sudo dmesg'
alias cal='LC_ALL=de_DE.utf8 cal'
alias yay='yay --editmenu'

function srv(){
  node -e '
  const {PORT = 8000} = process.env;
  require("http").createServer((req, res) => {
    process.stdout.write(`\n${req.method} ${req.url}\n`);

    Object.entries(req.headers).forEach(([key, value]) => {
      process.stdout.write(`${key}: ${value}\n`);
    });

    process.stdout.write("\n");
    req.on("data", (chunk) => {
      process.stdout.write(`${chunk.toString("utf-8")}`);
    });

    req.on("close", () => {
      process.stdout.write("\n");
      res.end("ok");
    });
  }).listen(PORT, () => console.log(`echo-server is listening on http://localhost:${PORT}`));
  '
}

function cheat(){
  curl -Lis cht.sh${*}
}

function radio(){
  term=$(echo $* | sed -r 's/\s/\+/g')
  curl http://opml.radiotime.com/Search.ashx\?query\=$term -s \
    | fxparser \
    | fx 'xx => xx.opml.body.outline.filter(x => x["@_item"] === "station").map(x=>[ x["@_URL"], x["@_reliability"], x["@_text"], x["@_subtext"] ].join("\t")).join("\n")' \
    | fzf --sync \
    | cut -f1 \
    | mpv --playlist=-
}

function dw(){
  url="https://de.wiktionary.org/wiki/$1"
  curl -s "$url" | hq 'table.wikitable' data | w3m -dump -T text/html | sed '/^$/d'
  echo $url
}

function www(){
  curl -s "$1" | w3m -dump -T text/html 
  echo $1
}

function todos(){
  EDITOR='vim -c "colorscheme gruvbox"' gh gist ${*:-view} ${GITHUB_GIST_TODOS}
}

function emojis(){
  e=`emojify --list | sed '0,/Supported emojis/d' | sort | fzf --reverse`
  echo $e | cut -d" " -f1 | xclip -rmlastnl -selection primary
  echo $e | cut -d" " -f2 | xclip -rmlastnl -selection clipboard
}

alias song='playerctl metadata title | EDITOR="tee -a" gh gist edit $GITHUB_GIST_SONGS'
alias songs='gh gist view $GITHUB_GIST_SONGS -f songs'

function record(){
  FILENAME=${1:-/tmp/`date "+%Y%m%d_%H%M%S"`.mp4}
  ffmpeg -f x11grab -r 30 `hacksaw -f "-s %wx%h -i :0.0+%x,%y"` -q:v 0 -q:a 0 $FILENAME
  echo $FILENAME
}

function co(){
  for handle in "$@"; do echo "Co-authored-by: $handle <$handle@users.noreply.github.com>"; done
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
    echo '$CONTENT' > /tmp/remind
    pkill -SIGRTMIN+4 i3blocks
    dunstify \"\`date\`\" '$CONTENT'
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

function ghcrio-on() {
  echo "{ \"auths\":{ \"ghcr.io\":{ \"auth\":\"`echo "$USER:$GITHUB_TOKEN" | base64`\"  }}}" > ${DOCKER_CONFIG:-$HOME/.docker/config.json}
}

function ghcrio-off() {
  rm -v ${DOCKER_CONFIG:-$HOME/.docker/config.json}
}

function aws-on(){
  export `pass ${PASSKEY:-seal/aws-teg-balazs4} | awk '/^AWS_/ {print $0}'`
}

function aws-off(){
  unset `env | awk -F= '/^AWS_/ {print $1 }'`
}

export N_PREFIX=$HOME/.n/prefix
export PATH=$HOME/.n/:$N_PREFIX/bin/:${PATH}
#vmware alias spotify='google-chrome-stable --app=https://open.spotify.com/' #webapp
alias youtube='google-chrome-stable https://youtube.com/' #webapp
#vmware alias whatsapp='chromium --app=https://web.whatsapp.com/' #webapp
#vmware alias infra="GH_REPO=sealsystems/com-infrastructure gh issue"
#vmware alias outlook='chromium --app=https://outlook.office365.com/mail/inbox' #webapp
#vmware alias teams='chromium --app="https://teams.microsoft.com/_#/conversations/General?threadId=19:1e2f67587cad457580ed4b3908f67431@thread.tacv2&ctx=channel"' #webapp
#vmware alias slack='chromium --app="$SLACK_URL"' #webapp
#vmware function jira(){
#vmware   case "$1" in
#vmware     board)
#vmware       shift;
#vmware       curl -u "$JIRA_AUTH" -Lis "https://$JIRA_URL/jira/rest/greenhopper/1.0/xboard/work/allData.json?rapidViewId=131" \
#vmware         | npx alola \
#vmware         | npx fx rapid \
#vmware         | fzf --sync -q "'${1:-bv} " --preview 'echo {} | cut -f1 | xargs -Iid zsh -c "source ~/.zshrc; jira id"' \
#vmware         | cut -f1 \
#vmware         | xargs -Iid zsh -c "source ~/.zshrc; jira id"
#vmware       ;;
#vmware 
#vmware     comment)
#vmware       shift;
#vmware       vipe --suffix md \
#vmware         | npx prettier --stdin-filepath _.md \
#vmware         | NODE_PATH=$N_PREFIX/lib/node_modules node -e "
#vmware           (async() => {
#vmware             const lines = [];
#vmware             for await (const line of require('readline').createInterface(process.stdin)){
#vmware               lines.push(require('jira2md').to_jira(line));
#vmware             }
#vmware             console.log(JSON.stringify({body: lines.join('\n')}));
#vmware           })();" \
#vmware         | curl -u "$JIRA_AUTH" -Lis "https://$JIRA_URL/jira/rest/api/2/issue/$1/comment" -H "Content-Type: application/json" -XPOST -d @- \
#vmware         | ALOLA_REPORT_ONLY=true npx alola 'status should be 201'
#vmware       ;;
#vmware 
#vmware     *)
#vmware       curl -u "$JIRA_AUTH" -Lis "https://$JIRA_URL/jira/rest/api/2/search?jql=key=$1" | npx alola | npx fx jira | glow -
#vmware       ;;
#vmware 
#vmware   esac
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
#vmware   docker compose -f "$HOME/git/plossys-bundle/docker-compose.yml" exec db mongo --tls --tlsAllowInvalidCertificates spooler-$1 --eval "db.$1.find($2).toArray()" \
#vmware     | sed '0,/MongoDB server version: 4.4.4/d'
#vmware }
#vmware 
#vmware function fixup(){
#vmware   npm run lint:fix || return 1
#vmware   git commit -a --fixup=HEAD
#vmware   git rebase -i origin --autosquash
#vmware   PAGER= git log --oneline -10
#vmware }

export PATH=$HOME/.cargo/bin:${PATH}

function yt(){
  [[ $# -eq 0 ]] && read stdin
  local search=`echo ${stdin:-*} | sed 's/\s/+/g'`
  curl -Lfs -H 'accept-language: en' "https://www.youtube.com/results?search_query=$search" \
    | pup 'script:contains("var ytInitialData") text{}' \
    | sed 's/var ytInitialData = //g;s/};/}/' \
    | fx youtubevideos \
    | fzf --sync \
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
    bluetoothctl power on
    device=`bluetoothctl devices | fzf -1 -q ${1:-""} | cut -d" " -f2`
    bluetoothctl connect $device
  fi
  pkill -SIGRTMIN+1 i3blocks
}
#carbon alias vercel='npx -q vercel -t $VERCEL_TOKEN'
#carbon alias vc='npx -q vercel -t $VERCEL_TOKEN'
#carbon alias whatsapp='google-chrome-stable --user-data-dir=$HOME/.config/webapp/whatsapp --app=https://web.whatsapp.com'
#carbon alias outlook='microsoft-edge-dev --user-data-dir=$HOME/.config/webapp/microsoft --app=https://outlook.com'
#carbon alias spotify='google-chrome-stable --user-data-dir=$HOME/.config/webapp/spotify --app=https://open.spotify.com/'
#carbon alias shop='google-chrome-stable --user-data-dir=$HOME/.config/webapp/shop'
#carbon alias bank='google-chrome-stable --user-data-dir=$HOME/.config/webapp/bank'
#carbon alias google='google-chrome-stable --user-data-dir=$HOME/.config/webapp/google'

function piserver(){
  curl -Lis http://192.168.178.42:180/admin/api.php | ALOLA_REPORT=text ALOLA_REPORT_ONLY=true npx alola \
    'status should be 200' \
    'headers.x-pi-hole should be The Pi-hole Web interface is working!'
}

#carbon function helloworld(){
#carbon   curl -H 'accept: application/json' -H "private-token: $GITLAB_TOKEN" "$GITLAB_HELLOWORLD_URL/issues?state=opened&confidential=true" -Lis \
#carbon     | npx alola \
#carbon     | npx fx .body 'x => x.map(xx => [xx.iid, xx.web_url, xx.created_at, xx.user_notes_count, xx.title].join("\t") ).join("\n")' \
#carbon     | fzf --preview-window='down,75%' --preview "echo {} | cut -f1 | xargs -Iid curl -H 'accept: application/json' -H 'private-token: $GITLAB_TOKEN' \"$GITLAB_HELLOWORLD_URL/issues/id/notes\" -Lisk | npx alola | npx fx 'x => x.body.map(xx => xx.body).join(\"\n\")'"
#carbon }


#vmware function testjob {
#vmware   local bytes=`echo ${1:-42kb} | sed -r 's/(m|mb)/ * 1024 * 1024/gi;s/(k|kb)/ * 1024/gi' | bc`
#vmware   local printer=${2:-`q printers '{ },{_id:1}' | npx fx ._id | fzf -1 --reverse --height=10 --sync`}
#vmware   local jobname=`echo $* | sed -r 's/\s/_/g'`
#vmware   rlpr -Hlocalhost -P$printer -J"$jobname" <<< `cat /dev/urandom | base64 | head -c $bytes` 2>&1 > /dev/null
#vmware }

#vmware function pickupjob(){
#vmware   local to="${1:-`q printers '{ "config.pickup": { $exists: false }  },{_id:1}' | npx fx ._id | fzf -1 --reverse --height=25 --sync --header='Select TARGET printer'`}"
#vmware   local from="${FROM:-`q printers '{ "config.pickup": { $exists: true }  },{_id:1}' | npx fx ._id | fzf -1 --reverse --height=25 --sync --header='Select SOURCE printer'`}"
#vmware 
#vmware   ipptool -j -vt ipp://localhost:6631/ipp/${from} ~/git/seal-ipp-checkin/vagrant/ipp/get-jobs.test \
#vmware     | grep 'job-' \
#vmware     | grep -v 'requested-attributes' \
#vmware     | cut -d'=' -f2 \
#vmware     | xargs -n9 \
#vmware     | sed 's/ /\t/g' \
#vmware     | fzf --reverse --height=25 --header="🖨 Printer terminal >>> Pickup job from ${from} at ${to}" \
#vmware     | cut -f8 \
#vmware     | xargs -t -I{} ipptool -vt -d uri="{}" -d printer="${to}" ~/git/seal-ipp-checkin/vagrant/ipp/release-job.test 
#vmware }


function qrdecode {
  shotgun `hacksaw -f "-i %i -g %g"` - | zbarimg -q --raw -
}

function wallomat {
  # wallomat 6D-A6CL3Pv8 24
  mpv "https://www.youtube.com/watch?v=$1&t=$2" --no-audio --frames=1 -o /tmp/mpv.png
  feh --no-fehbg --bg-fill /tmp/mpv.png
}


#vmware function sealnode {
#vmware   curl -H 'Cache-Control: no-cache' -s "https://$GITHUB_TOKEN@raw.githubusercontent.com/sealsystems/generator-seal-node/master/lib/constants.js" | grep "NODE_VERSION" | cut -f2 -d"'" | xargs -t n install
#vmware   node -v
#vmware   npm -v
#vmware }


alias feedback="npx -q -y onchange -i -k './**/*.js' -- npm run test"

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
`fd --type f | xargs -I{} echo "      - './{}:/usr/share/nginx/html/{}:ro'"`
" | vipe --suffix .yml > $DOCKER_COMPOSE

  docker compose -f $DOCKER_COMPOSE up
  rm -f $DOCKER_COMPOSE
}

alias pnpm='NPM_CONFIG_LOGLEVEL=error npx -y pnpm'
alias pn='NPM_CONFIG_LOGLEVEL=error npx -y pnpm'
alias yarn='NPM_CONFIG_LOGLEVEL=error npx -y yarn'

function burger(){
  source $HOME/git/aws-burger/functions
}

function now(){
  local artUrl=`playerctl metadata --format '{{mpris:artUrl}}'`
  local title="`playerctl metadata --format '{{title}}'`"
  local artist="`playerctl metadata --format '{{artist}}'`"
  local searchterm=`node -p "encodeURIComponent('$artist $title')"`

  [[ $artUrl ]] && curl -s $artUrl -o /tmp/$searchterm.png

  if [[ ! -f /tmp/$searchterm.png ]]
  then
    curl -Lisk "https://api.deezer.com/search?strict=on&q=$searchterm" \
      | ALOLA_REPORT=silent npx alola 'status should be 200' \
      | npx fx 'x => x.body.data.map(xx => xx.album.cover_medium).join("\n")' \
      | head -1 \
      | xargs -I{} curl -s {} -o /tmp/$searchterm.png
  fi

  dunstify -I /tmp/$searchterm.png "$title" "$artist"
}

#vmware function ropa(){
#vmware   local bazz=$1
#vmware   shift
#vmware   local foo=`node -p "JSON.stringify('${*}'.split(' ').reduce((x, y) => ({...x, [y]: 1}), {}))"`
#vmware   local bar=`node -p "JSON.stringify('${*}'.split(' '))"`
#vmware   watch -n2 -d  "docker compose -f $HOME/git/plossys-bundle/docker-compose.yml exec db mongo --tls --tlsAllowInvalidCertificates spooler-${bazz} --eval 'db.${bazz}.find({},${foo})' | sed '0,/MongoDB server version: 4.4.4/d' | fx 'x => ${bar}.map(k => k.split(\".\").reduce((p, c) => p[c]||\"-\", x)).join(\"\t\")'"
#vmware }

function news(){
  tmux new-session -s 'news' -d

  tmux rename-window -t "news.1" "wttr"
  tmux send-keys -t "news:wttr.1" "curl -s http://wttr.in/91085" Enter

  tmux new-window -t "news" -n "hackernews"
  tmux send-keys -t "news:hackernews.1" "hackernews 10" Enter

  tmux new-window -t "news" -n "r/commandline"
  tmux send-keys -t "news:r/commandline.1" "reddit commandline" Enter

  tmux new-window -t "news" -n "archnews"
  tmux send-keys -t "news:archnews.1" "archnews" Enter

  tmux attach-session -t 'news'
}

function hackernews(){
  curl -Lis https://hacker-news.firebaseio.com/v0/topstories.json \
    | ALOLA_REPORT=silent alola 'status should be 200' \
    | fx "x=> x.body.slice(0,${1:-10}).join(\"\n\")" \
    | xargs -I{} curl -s https://hacker-news.firebaseio.com/v0/item/{}.json \
    | fx 'x => [`\x1b[2m${x.url}\x1b[0m`, `\x1b[1m${x.title}\x1b[0m`, " "].join("\n")' 
}

function reddit(){
  curl -Ls --user-agent "$RANDOM" "https://www.reddit.com/r/${1:-all}.json"\
    | fx 'x => x.data.children.slice(10).map(xx => [`\x1b[2m${xx.data.url}\x1b[0m`, `\x1b[1m${xx.data.title}\x1b[0m (${xx.data.subreddit_name_prefixed})`, " "].join("\n")).join("\n")'
}

function archnews(){
  curl -s https://archlinux.org/feeds/news/ \
    | fxparser \
    | fx 'x => x.rss.channel.item.map(xx => [`\x1b[2m${xx.link}\x1b[0m`, new Date(xx.pubDate).toJSON() + ` >> \x1b[1m${xx.title}\x1b[0m`, " "].join("\n")).join("\n")'
}

alias magic="echo ✨MAGIC✨. Sorry-not-sorry"
alias screensaver='tmux new-session -s xcowsay -d "while true; do xcowsay catch me if you can; done";exit'

function mongodb-rs(){
  docker ps -a | grep 27017 | cut -f1 -d" " | xargs -tr docker kill
  docker run -d --rm -p "27017:27017" mongo:${1:-4.4.4} --replSet rs \
    | xargs -I{} docker exec -i {} sh -c '
      while ! mongo  --eval "db.version()" >/dev/null; do sleep 0.5s; done; \
      mongo --eval "rs.initiate()"; \
      while ! mongo  --eval "rs.status().members[0].stateStr" | grep PRIMARY; do sleep 0.5s; done; \
      mongo --eval "db.createCollection(\"test\")"
      '
  docker ps -a | grep 27017 
}

function dcargo(){
  docker run -it --rm --user `id -u`:`id -g` -v "$PWD:/`basename $PWD`" -w /`basename $PWD` ghcr.io/rust-lang/rust:nightly-alpine cargo $@
}

#carbon function deskon(){
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
#carbon function deskoff(){
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


function record-tmux(){
  local cast="/tmp/tmux-$1.json"
  asciinema rec --command "tmux attach -t $1" $cast
  #npx -yq -p svg-term-cli
  svg-term --in $cast --out $cast.svg
  ls -lsh $cast*
}

function typo(){
  local target=$1
  shift
  node -p 'process.argv.slice(1).map(x => x.split("").map(xx => xx + "\n").join("")).join("\n").trim()' ${*} \
    | xargs -I% -d '\n' -n1 sh -c "tmux send-keys -t '$target' '%'; sleep 0.1s;"

  sleep 0.2s
  tmux send-keys -t "$target" Enter
}

test -f $HOME/.nix-profile/etc/profile.d/nix.sh && source $HOME/.nix-profile/etc/profile.d/nix.sh

function raw(){
  curl -Ls "$1?raw=true"
}

function yayfzf(){
  yay -Sy
  yay -Slq | fzf --preview 'yay -Si {1}' --query "'${1}" -1 | xargs yay -Sy --noconfirm 
  hash -r
}
alias yf=yayfzf
alias yzf=yayfzf
alias yayf=yayfzf

function gitlab-pipeline(){
  # deps:
  # - curl
  # - git
  # - awk
  # - xurls - https://github.com/mvdan/xurls
  # - GITLAB_AUTH_TOKEN - https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html
  local project=`git config --get remote.origin.url | awk -F: '{ sub(/\.git$/,""); sub(/\//,"%2F");  print $2}'`
  local sha=`git rev-parse HEAD`
  local ref=`git rev-parse --abbrev-ref HEAD`

  curl -Ls -H "private-token: $GITLAB_AUTH_TOKEN" "https://gitlab.com/api/v4/projects/$project/pipelines/?sha=$sha&ref=$ref" \
    | xurls \
#carbon    | xargs xdg-open
#macos    | xargs -open
}

function gb(){
  git branch -a \
    | grep -v HEAD \
    | fzf -1 -q "${*}" \
    | sed 's|remotes/origin/||g' \
    | xargs git checkout
}
