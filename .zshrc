HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history
#mcbpro export HOMEBREW_PREFIX="/opt/homebrew";
#mcbpro export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
#mcbpro export HOMEBREW_REPOSITORY="/opt/homebrew";
#mcbpro export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
#mcbpro export PATH="/opt/homebrew/opt/curl/bin:$PATH"
#mcbpro export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
#mcbpro export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
#mcbpro FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
#mcbpro export PATH="$HOME/.luarocks/bin:${PATH}"
#mcbpro export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
#mcbpro export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
#mcbpro alias xdg-open='open'
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
  git status --porcelain --branch --no-ahead-behind 2>&1 \
    | gawk '
      BEGIN                             {branch;staged=0;modified=0;untracked=0}
      /^fatal: /                        {exit;}
      /^##/                             {sub(/\.\.\./," "); branch=$2}
      /^##.*\[different\]$/             {branch=$4branch }
      /^## No commits yet/              {branch="???"}
      /^(M|T|A|D|R|C|U) /               {staged++}
      /^ (M|T|A|D|R|C|U)/               {modified++}
      /^(M|T|A|D|R|C|U)(M|T|A|D|R|C|U)/ {staged++; modified++}
      /^\?\?/                           {untracked++}
      END { if ($1 != "fatal:") print "%F{#{{base07-hex}}} [ %f" branch "«%B%F{green}" staged "%f%b«%B%F{red}" modified "%f%b«%B%F{red}" untracked "%f%b %F{#{{base07-hex}}}]%f" }' \
    | sed 's|%B%F{green}0%f%b|0|g;s|%B%F{red}0%f%b|0|g;s|\[different\]|%B%F{red}! %f%b|g'
}

setopt PROMPT_SUBST

function TRAPUSR1(){
  source $HOME/.zshrc
  source $HOME/.zshenv
  tmux source-file $HOME/.tmux.conf 2>/dev/null || true
#carbon  killall -USR1 sxhkd
  echo "TRAPUSR1" >&2
}


function zle-line-init zle-keymap-select {
  test $COLUMNS -lt 100 && NEWLINE=$'\n' || NEWLINE=''
  PROMPT="%B%F{#{{base07-hex}}} %~%f%b$(zsh-git &) %B%F{#{{base07-hex}}}${NEWLINE}»%f%b "
  RPROMPT="%(?.%F{#{{base07-hex}}}.%F{red})%?%f `[[ $KEYMAP == 'vicmd' ]] && echo '[normal]'`"
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1

function zz() {
  local to=`{
    echo $HOME/.files;
    find $HOME/src -maxdepth 1 -type d;
#mcbpro    find $HOME/src/api/services -maxdepth 1 -type d;
  } | fzf --layout=reverse --height '40%' -q "${*:-$PWD} " -1 --preview 'ls {}'`

  [[ $TMUX ]] \
    && cd ${to:-$PWD} \
    || tmux new-session -A -s ${to:-$PWD} -c ${to:-$PWD}
}

alias z='TMUX=fake zz'

function zzz() {
  mkdir -p $HOME/src/$1
  git init $HOME/src/$1
  git -C $HOME/src/$1 commit -m batman --allow-empty
  zz $1
}

#carbon source /usr/share/fzf/completion.zsh
#carbon source /usr/share/fzf/key-bindings.zsh
#mcbpro source /opt/homebrew/opt/fzf/shell/completion.zsh
#mcbpro source /opt/homebrew/opt/fzf/shell/key-bindings.zsh

export LANG=en_US.UTF-8
export TERMINAL=alacritty
export TERM=xterm-256color
#mcbpro export BROWSER=open
#carbon export BROWSER=chromium
export EDITOR=nvim
export FZF_DEFAULT_COMMAND="fd --hidden --type=f -E node_modules -E .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--no-separator --bind 'ctrl-x:execute-silent(echo {} | xurls | xargs xdg-open)'"
export GPG_TTY=`tty`
export RIPGREP_CONFIG_PATH=$HOME/.rgrc
export PATH=$HOME/.local/bin:${PATH}

#nodejs
#carbon export NPM_CONFIG_LOGLEVEL=http
#mcbpro export NPM_CONFIG_LOGLEVEL=error
export DOTENV_CONFIG_DEBUG=true
export N_PREFIX=$HOME/.n/prefix
export N_PRESERVE_NPM=1
export PATH=$HOME/.n/:$N_PREFIX/bin/:${PATH}
export PATH=./node_modules/.bin/:${PATH}
#mcbpro export PNPM_HOME=$HOME/.pnpm-global
#mcbpro export PATH=$PNPM_HOME:${PATH}

#go
export GOPATH=$HOME/.go
export PATH=${GOPATH}/bin:${PATH}

#rust
export PATH=$HOME/.cargo/bin:$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/:${PATH}

#bun
export DO_NOT_TRACK=1

function dot(){
  case "$1" in
    "git")
      shift
      git -C "$HOME/.files/" ${*}
      ;;

    "sync")
      git -C "$HOME/.files/" commit -am "`date +%s`@`hostname -s`"
      git -C "$HOME/.files/" pull
      git -C "$HOME/.files/" push
      dot "source"
      ;;

    "file")
      shift
      [[ -e "$HOME/$1" ]] || return
      dir=`dirname "$HOME/.files/$1"`
      mkdir -p $dir
      cp -v "$HOME/$1" "$HOME/.files/$1"
      git -C "$HOME/.files/" add "$1"
      git -C "$HOME/.files/" commit -m "add: $1"
      ;;

    "source")
      TMUX= source $HOME/.files/.zprofile
      source $HOME/.zshrc && printf ".zshrc sourced"
      test $TMUX && {tmux source-file $HOME/.tmux.conf 2>/dev/null && printf "\t.tmux.conf sourced"} || true
      printf "\n"
      ;;

    *)
      pushd $HOME/.files > /dev/null
        nvim `git ls-files | fzf --height '25%' --sync --reverse -1 -q"'${1}"`
      popd > /dev/null
      dot "source"
      ;;
  esac
}

function nvimplug(){
  if [[ ! -z "$1" ]]
  then
    echo "\n-- $1" >> $HOME/.files/.config/nvim/init.lua
    local name=`echo $1 | awk -F/ '{print $NF}'`
    echo "require('$name').setup()" >> $HOME/.files/.config/nvim/init.lua
    TMUX= source $HOME/.files/.zprofile
    git -C $HOME/.local/share/nvim/site/pack/_/start/ clone --depth=1 $1
    return
  fi

  rm -rf $HOME/.local/share/nvim/site/pack/_/start/* 2>/dev/null
  mkdir -p $HOME/.local/share/nvim/site/pack/_/start/ 2>/dev/null

  pushd $HOME/.local/share/nvim/site/pack/_/start/
    grep '^\s*-- https://github' $HOME/.config/nvim/init.lua | sed 's/^[[:space:]]*-- //g' | xargs -t -L1 git clone --depth=1
  popd
}

alias so='vim $HOME/.zshenv; source $HOME/.zshenv'
alias tmuxrc='dot .tmux.conf'
alias zshrc='dot .zshrc'
alias nvimrc='dot .config/nvim/init.lua'
#carbon alias sx="dot .config/sxhkd/sxhkdrc; killall -USR1 sxhkd"
alias wttr="curl -H 'cache-control: no-cache' -s 'http://wttr.in/91085?format=3'"
#carbon alias xx='xclip -rmlastnl -selection clipboard'
#mcbpro alias xx='pbcopy'
alias ls='ls --color=auto'
alias grep='grep --color'
alias :q='exit'
alias :q!='exit'
alias ll='ls -hal'
alias rm='rm -i'
alias yolo='git add . && git commit -m "yolo commit :sponge:" --no-verify && git push --no-verify || true'
alias http="node -p \"Object.entries(require('http').STATUS_CODES).map(x=> x.join('\t')).join('\n')\" | fzf --sync --reverse --height=25%"
alias ssh='TERM=xterm-256color ssh'
alias scpignore="scp -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null"
alias sshignore="ssh -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null"
alias gd='git diff'
alias gst='git status'
alias gco='git checkout'
alias gpp='git pull --prune --tags'
alias gcm='git checkout `git branch | grep -m 1 -E "^\s+(canary|main|master)$" | sed "s|^* ||g"`'
alias gf="git ls-files --modified"
alias gff="git ls-files"
alias gtree='git ls-files | tree --fromfile'
alias gmv='git ls-files | vidir - && git status'
alias gpick='git log --oneline --color | fzf -m --ansi --preview "git show --color {1}" | awk "{print $1}"'
alias shrug='curl -s http://shrug.io | xx'
alias wipe='docker rm -f `docker ps -aq`'
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
  PORT=8000 node -e '
  require("node:http").createServer(async (req, res) => {
    process.stdout.write("\n");
    process.stdout.write(req.method + " " + req.url);
    process.stdout.write("\n");
    Object.entries(req.headers).forEach(([key, value]) => {
      process.stdout.write(key + ": " + value);
      process.stdout.write("\n");
    });

    if (req.method.toUpperCase() !== "GET"){
      process.stdout.write("\n");
      await require("node:stream/promises")
        .pipeline(
          req,
          async function*(source) {
            for await (const chunk of source){
              process.stdout.write(chunk);
            }
          }
        ).catch();
      process.stdout.write("\n");
    }

    process.stdout.write("\n");
    res.writeHead(200, { "content-type": "text/plain" });
    res.end();
  }).listen(process.env.PORT, () => console.log("http://localhost:" + process.env.PORT));
  '
}

function cheat(){
  curl -Lis cht.sh${*} | less -r
}

function radio(){
  test $# -eq 0 && {
    echo "no search term, no radio"
    return 1
  }
  test $TMUX && {
    local target=`tmux display-message -p '#I'`
    tmux rename-window -t:$target radio
  }
  term=$(echo $* | tr ' ' '+')
  curl http://opml.radiotime.com/Search.ashx\?query\=$term -s \
    | fxparser \
    | fx 'xx => xx.opml.body.outline.filter(x => x["@_item"] === "station").map(x=>[ x["@_URL"], x["@_reliability"], x["@_text"], x["@_subtext"] ].join("\t")).join("\n")' \
    | fzf --sync --reverse --height=50% \
    | cut -f1 \
    | mpv ${MPV} --playlist=-
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
  >&2 echo $url
}

#carbon function emojis(){
#carbon   emojify --list \
#carbon     | sed '0,/Supported emojis/d' \
#carbon     | sort \
#carbon     | fzf --reverse \
#carbon     | awk '{print $1 | "xclip -rmlastnl -selection primary" }; {print $2 | "xclip -rmlastnl -selection clipboard" }'
#carbon }

function track(){
  test -e $HOME/.cache/spotify || {
    local url="https://accounts.spotify.com/authorize?client_id=${SPOTIFY_CLIENT_ID}&response_type=code&redirect_uri=http://localhost:8000/&scope=playlist-modify-public"
#carbon    (google-chrome-stable --user-data-dir=$HOME/.config/webapp/spotify $url 1>/dev/null 2>/dev/null &)
#mcbpro    open $url
    local spotify_code=`node -e "
    require('node:http').createServer((req, res) => {
      res.end('you can close this tab');
      const code = new URL('http://localhost:8000' + req.url).searchParams.get('code');
      console.log(code);
      process.exit(0);
    }).listen(8000);"`

#carbon    killall -9 chrome

    curl "https://accounts.spotify.com/api/token" \
      -XPOST \
      -H "Content-Type: application/x-www-form-urlencoded" \
      -d "grant_type=authorization_code&code=$spotify_code&client_id=$SPOTIFY_CLIENT_ID&client_secret=$SPOTIFY_CLIENT_SECRET&redirect_uri=http://localhost:8000/" \
      -o $HOME/.cache/spotify
  }

#carbon  local last_changed=`stat --format=%Y $HOME/.cache/spotify`
#mcbpro  local last_changed=`stat -f %m $HOME/.cache/spotify`
  local now=`date +%s`
  local expires_in=`cat $HOME/.cache/spotify | fx .expires_in`

  test $(($now - $last_changed)) -ge $expires_in && {
    local refresh_token=`cat $HOME/.cache/spotify | fx .refresh_token`
    curl "https://accounts.spotify.com/api/token" \
      -XPOST \
      -H "Content-Type: application/x-www-form-urlencoded" \
      -u "$SPOTIFY_CLIENT_ID:$SPOTIFY_CLIENT_SECRET" \
      -d "grant_type=refresh_token&refresh_token=$refresh_token&client_id=$SPOTIFY_CLIENT_ID&scope=playlist-modify-public" \
      | fx "x => ({refresh_token: '$refresh_token', ...x})" > $HOME/.cache/spotify
  }

  local access_token=`cat $HOME/.cache/spotify | fx .access_token`

  local icy_title=`tmux capture-pane -p -t radio | awk -F':' '/icy-title:/ {print $2}' | tail -1 | sed 's/ //'`
  local icy_title_encoded=`node -p 'encodeURIComponent(process.argv[1])' "${icy_title}"`

  local spotify_track_uri=`curl "https://api.spotify.com/v1/search?type=track&market=DE&limit=1&q=${icy_title_encoded}" \
    --oauth2-bearer $access_token \
    -LisS \
    | alola 'status should be 200' 'body.tracks.items.length should be 1' 'body.tracks.items.0.uri should not be undefined' 2>/dev/null \
    | fx 'x => x.body.tracks.items[0].uri'`

  local body=`node -p "JSON.stringify({uris: ['${spotify_track_uri}'], position: 0})"`

  curl "https://api.spotify.com/v1/playlists/${SPOTIFY_PLAYLIST_ID}/tracks" \
    --oauth2-bearer $access_token \
    -X POST \
    -H 'Content-Type: application/json' \
    -d "$body" \
    -LisS \
    | alola 'status should be 201' 2>/dev/null 1>/dev/null

  echo "https://open.spotify.com/playlist/${SPOTIFY_PLAYLIST_ID}"
  echo  $spotify_track_uri | sed 's|:|/|g; s|spotify|https://open.spotify.com|g';
  echo "$icy_title"
}

function record(){
  local filename=${1:-/tmp/`date "+%Y%m%d_%H%M%S"`.mp4}
  echo "Press [q] when you want to stop recording."
  ffmpeg -hide_banner -loglevel panic -f x11grab -r 30 `hacksaw -f "-s %wx%h -i :0.0+%x,%y"` -c:v libx264 $filename
  echo $filename
}

function co(){
  for handle in "$@"; do echo "Co-authored-by: $handle <$handle@users.noreply.github.com>"; done
}

#carbon function mirrorlist() {
#carbon   COUNTRIES=`echo ${*:-DE NL}| xargs -d" " -I{} echo -n "&country={}"`
#carbon   curl -s "https://archlinux.org/mirrorlist/?protocol=https&ip_version=4${COUNTRIES}" \
#carbon     | sed "s/#Server/Server/g" \
#carbon     | sudo tee /etc/pacman.d/mirrorlist
#carbon }


function touchd(){
  mkdir -p `dirname "$1"` && touch "$1"
}

function wall(){
  local unsplash_id=`echo $1 | awk -F- '{print $NF}'`
  sed -i "s|#`hostname` exec_always feh --no-fehbg --bg-fill https://unsplash.com/photos/\(.*\)/download?force=true|#`hostname` exec_always feh --no-fehbg --bg-fill https://unsplash.com/photos/$unsplash_id/download?force=true|g" $HOME/.files/.config/i3/config
  dot source
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
  test $TMUX && {
    local target=`tmux display-message -p '#I'`
    tmux rename-window -t:$target youtube
  }
  echo $* \
    | tr ' ' '+' \
    | xargs -t -I{} curl -Lfs -H "accept-language: ${LNG:-en}" https://www.youtube.com/results\?search_query={} \
    | pup 'script:contains("var ytInitialData") text{}' \
    | sed 's/var ytInitialData = //g; s/};/}/' \
    | node -e '
      (async() => {
        const lines = [];
        for await (const line of require("node:readline").createInterface(process.stdin)) {
          lines.push(line);
        }
        const yt = JSON.parse(lines.join("\n"));
        const result = yt
          .contents
          .twoColumnSearchResultsRenderer
          .primaryContents
          .sectionListRenderer
          .contents[0]
          .itemSectionRenderer
          .contents
          .filter(x => x?.videoRenderer)
          .map(x =>
          [
            x.videoRenderer.videoId,
            x.videoRenderer.lengthText?.simpleText?.padStart(8),
            x.videoRenderer.viewCountText?.simpleText?.padStart(16),
            x.videoRenderer.title?.runs[0].text,
            x.videoRenderer.thumbnail?.thumbnails[0]?.url
          ].join("\t")
        ).join("\n");

        console.log(result);
      })();
      ' \
    | sort -k3 -rh \
    | fzf --sync --reverse \
    | cut -f1 \
    | xargs -t -Iwatch mpv ${MPV:---ytdl-format='[height=1080]/best'} https://youtu.be/watch
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
#carbon alias outlook='google-chrome-stable --user-data-dir=$HOME/.config/webapp/microsoft --app=https://outlook.com'
#carbon alias spotify='google-chrome-stable --user-data-dir=$HOME/.config/webapp/spotify --app=https://open.spotify.com/'
#carbon alias shop='google-chrome-stable --user-data-dir=$HOME/.config/webapp/shop'
#carbon alias bank='google-chrome-stable --user-data-dir=$HOME/.config/webapp/bank'
#carbon alias google='google-chrome-stable --user-data-dir=$HOME/.config/webapp/google'

function pihole(){
  curl -Lis http://192.168.178.42/admin/api.php \
    | npx alola 'status should be 200' 'headers.x-pi-hole should be The Pi-hole Web interface is working!' 1>/dev/null
}


function qrdecode {
  shotgun `hacksaw -f "-i %i -g %g"` - | zbarimg -q --raw -
}

#carbon function now(){
#carbon   local artUrl="`mpris-ctl info '%art_url'`"
#carbon   local title="`mpris-ctl info '%track_name'`"
#carbon   local artist="`mpris-ctl info '%artist_name'`"
#carbon   local searchterm=`node -p "encodeURIComponent('$artist $title'.trim())"`
#carbon
#carbon   [[ $artUrl ]] && curl -s $artUrl -o /tmp/$searchterm.png
#carbon
#carbon   if [[ ! -f /tmp/$searchterm.png ]]
#carbon   then
#carbon     curl -Lisk "https://api.deezer.com/search?strict=on&q=$searchterm" \
#carbon       | alola 'status should be 200' \
#carbon       | fx 'x => x.body.data.map(xx => xx.album.cover_medium).join("\n")' \
#carbon       | head -1 \
#carbon       | xargs -I{} curl -s {} -o /tmp/$searchterm.png
#carbon   fi
#carbon
#carbon   dunstify -I /tmp/$searchterm.png "$title" "$artist"
#carbon }

function news(){
  tmux new-session -s 'news' -d

  tmux rename-window -t "news.1" "wttr"
  tmux send-keys -t "news:wttr.1" "curl -s v2.wttr.in/91085" Enter

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
    | fx 'x => [x.url, x.title].join("\t")' \
    | fzf --with-nth="2.." --preview 'echo {} | xurls | xargs reader -i -o'
}

function reddit(){
  curl -H 'cache-control: no-cache' -Ls --user-agent "$RANDOM" "https://www.reddit.com/r/${1:-all}/hot.json"\
    | fx 'x => x.data.children.slice(10).map(xx => [`\x1b[2m${xx.data.url}\x1b[0m`, `\x1b[1m${xx.data.title}\x1b[0m (${xx.data.subreddit_name_prefixed})`, " "].join("\n")).join("\n")' \
    | sed 's/www.reddit.com/old.reddit.com/g'
}

function archnews(){
  curl -s https://archlinux.org/feeds/news/ \
    | fxparser \
    | fx 'x => x.rss.channel.item.map(xx => [`\x1b[2m${xx.link}\x1b[0m`, new Date(xx.pubDate).toJSON() + ` >> \x1b[1m${xx.title}\x1b[0m`, " "].join("\n")).join("\n")'
}

#carbon function dp2(){
#carbon   xrandr \
#carbon     --dpi 136 \
#carbon     --output eDP1 --primary --mode 1920x1080 --pos 800x2160 --rotate normal --scale 1.4 \
#carbon     --output DP1 --off \
#carbon     --output DP2 --mode 3840x2160 --pos 0x0 --rotate normal \
#carbon     --output HDMI1 --off
#carbon
#carbon    echo "Xft.dpi: 136" | xrdb -merge
#carbon    i3-msg restart
#carbon    imwheel >/dev/null &
#carbon }
#carbon
#carbon function edp(){
#carbon   xrandr \
#carbon     --dpi 96 \
#carbon     --output eDP1 --primary --mode 1920x1080 --rotate normal --scale 1.0 \
#carbon     --output DP1 --off \
#carbon     --output DP2 --off \
#carbon     --output HDMI1 --off
#carbon
#carbon    echo "Xft.dpi: 96" | xrdb -merge
#carbon    i3-msg restart
#carbon    killall -9 imwheel >/dev/null
#carbon }

#carbon function hdmi(){
#carbon   xrandr --output HDMI1 --mode 1920x1080 --pos 0x0 --rotate normal
#carbon }

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
    | xargs open
}

function gb(){
  git branch -a \
    | grep -v HEAD \
    | fzf -1 -q "'${*} " \
    | sed 's|remotes/origin/||g;s|^*||g' \
    | xargs -t git checkout
}

alias gbb='gb $USER'

alias .env='set -o allexport; source .env; set +o allexport'

alias src='fx package.json .scripts'

#mcbpro export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
#mcbpro export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"
#mcbpro export BUILD_LIBRDKAFKA=0

#carbon function cool(){
#carbon   echo level ${1:-7} | sudo tee /proc/acpi/ibm/fan
#carbon }

function fmt(){
    xargs -t bun x prettier --ignore-unknown --write
    #xargs bunx @biomejs/biome format --write --quote-style=single --indent-style=space
}
alias gfmt='git ls-files --modified | fmt'
alias fmtg='git ls-files --modified | fmt'

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

function s3fzf(){
  aws s3 ls ${1} --recursive \
    | fzf --preview "aws s3 cp ${1}{4} -" \
    | awk '{print $NF}' \
    | xargs -I{} aws s3 cp ${1}{} -
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
      console.log(JSON.stringify(jwt, null,2));
    }
  })();
  "
}

function ip() {
  dig $1 | awk "/^$1/ {print \$NF}"
}

function contrib(){
  {
    gh api --paginate "/search/issues?per_page=100&q=org:$GITHUB_ORG+sort:created+created:>$GITHUB_START+author:${GITHUB_USER:-@me}+is:pr";
  } \
    | fx 'x => x.items.map(xx => [xx.created_at, xx.html_url.padEnd(64), "+" + xx.reactions["heart"], xx.assignee?.login || xx.user.login, "»»" , xx.title].join("\t")).join("\n")' \
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

alias carbonyl='docker run --rm -it -v carbonyl:/carbonyl/data fathyb/carbonyl'

function x(){
  tmux new-session -A -s $HOME -c $HOME
}

function redis(){
  docker run --rm -d --name redis-server -p 6379:6379 redis
  docker ps
}

function redis-cli(){
  local id=`docker run --rm -d redis:alpine`
  docker exec -it ${id} redis-cli
  docker rm -f $id
}

function dynamo(){
  docker run --rm -d --name dynamodb-local -p 4133:8000 amazon/dynamodb-local
  docker ps
}

function closest_packagejson(){
  local git_root=`git rev-parse --show-toplevel`
  local file='package.json'
  local real_path=`realpath $1`
  local dir=`dirname $real_path`
  test -d $realpath && dir=$real_path
  while true
  do
    test -f $dir/$file && { echo $dir; return 0; }
    test "$dir" = "$git_root" && return 1;
    dir=`dirname $dir`
  done
}

function npmw(){
  local script="${1:-test}"
  local file=${2:-$PWD}
  shift
  local dir=`closest_packagejson $file`
  if test "${script}" = 'test'
  then
    script="${script} -- ${file}"
  fi
  pushd $dir
    watchexec -vv -c --print-events --project-origin $PWD -s SIGKILL --stop-timeout 0 -- npm run "${script} ${*}"
  popd
}

function makew() {
    watchexec -v -c --print-events --project-origin $PWD -s SIGKILL --stop-timeout 0 -- make "${*}"
}

#mcbpro function na(){
#mcbpro   n auto
#mcbpro   grep private $HOME/.npmrc > /dev/null || $HOME/.local/bin/npmrc
#mcbpro   pnpm install --frozen-lockfile
#mcbpro }

function epoch(){
  node -p "new Date($1).toJSON();"
}

function servus(){
  PORT=4269 watchexec --project-origin $PWD --print-events --no-meta --shell=none --signal=SIGUSR2 -- node -e '
  require("node:http").createServer((req,res) => {
    if (req.url === "/.servus" ){
      res.writeHead(200,{ "content-type": "text/event-stream", "connection": "keep-alive", "cache-control": "no-cache" });
      const handler = () => res.write("data: servus pid:" + require("node:process").pid + "\n\n");
      res.on("close", () => require("node:process").off("SIGUSR2", handler));
      require("node:process").on("SIGUSR2", handler);
      return;
    }

    if (req.url === "/favicon.ico") return res.end("shut up chromium");

    let filename = req.url;
    if (filename.endsWith("/") === true ) filename = filename + "index.html";
    if (filename.includes(".") === false) filename = filename + ".html";
    const file = require("node:path").join(process.env.PWD, filename);

    require("node:stream").pipeline(
      require("node:fs").createReadStream(file),
      async function* (source) {
        for await (const chunk of source){ yield chunk; }
        if (filename.endsWith(".html") === true){ yield "<script>new EventSource(\"/.servus\").onmessage = function(){ location.reload();}</script>"; }
      },
      res,
      err => {
        if (err) res.statusCode = 404;
        res.statusText = require("node:http").STATUS_CODES[res.statusCode];
        console.log([req.method, req.url, res.statusCode, res.statusText, err?.message].join(" "))
      }
   );

  }).listen(process.env.PORT, () => console.log("[servus:pid=" + require("node:process").pid + "] http://localhost:" + process.env.PORT));
  '
}

function mkdird() {
  mkdir -p $1
  pushd $1
}

alias stars="xdg-open 'https://github.com/balazs4?tab=stars'"

#carbon alias xb='xbacklight -set'

function base16(){
  local schemes_folder=$HOME/.cache/schemes
  git clone https://github.com/tinted-theming/schemes $schemes_folder --depth=1 2>/dev/null || git -C $schemes_folder pull

  local base16_theme=$schemes_folder/base16/`git -C $schemes_folder/base16 ls-files | fzf --height='40%' --reverse --preview "cat $schemes_folder/base16/{}" -q"${*} " -1`

  sed '/FOE/,/EOF/{//!d}' $HOME/.files/.zprofile \
    | awk "/FOE/ {print; system(\"cat ${base16_theme}\"); print\"\"; next} 1" \
    | sponge $HOME/.files/.zprofile

  TMUX= source $HOME/.files/.zprofile
  source $HOME/.zshrc
  kill -USR1 `pgrep zsh` 2>/dev/null
}

function dark(){
#mcbpro   osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = true" > /dev/null
  base16 \!light ${*}
}

function light(){
#mcbpro   osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = false" > /dev/null
  base16 \'light ${*}
}

function parrot(){
  curl --max-time ${1:-3} parrot.live 2>/dev/null
}

alias kw='gdate +"current calendar week: %U"'

function a(){
#carbon  (pidof xcompmgr || xcompmgr & ) > /dev/null
  sed "s/^opacity = .*/opacity = 0.${1:-99}/" -i $HOME/.alacritty.toml
}

#carbon function nyc(){
#carbon   mpv "https://www.youtube.com/watch?v=Gx6NVCRyMzk&t=$(( ( RANDOM % 236 ) + 1 ))" --no-audio --frames=1 -o /tmp/nyc.png \
#carbon     && feh --no-fehbg --bg-fill /tmp/nyc.png
#carbon }

#mcbpro function dog(){
#mcbpro   local service=`git -C $HOME/src/api ls-files | grep services | grep package.json | awk -F/ '{print $2}' | fzf -1 --height '25%' -q"${1}"`
#mcbpro   open "https://app.datadoghq.com/logs/livetail?query=service%3A${service}%20&cols=host%2Cservice&index=%2A&messageDisplay=inline&refresh_mode=sliding&storage=live&stream_sort=desc&view=spans&viz=stream&live=true"
#mcbpro }

export BUILDKIT_PROGRESS=plain

function bs(){
  # (n)vim integration: $HOME/.local/bin/bs (or something on path)
  # #! /usr/bin/zsh
  # source $HOME/.zshrc; bs ${*}

  test -z $OPENAI_API_KEY && export OPENAI_API_KEY=`pass openai`

  node -e '
  (async function() {
    const lines = [];
    for await (const line of require("node:readline").createInterface(process.stdin)){ lines.push(line); }
    const prompt = { model: "gpt-3.5-turbo-0125",  messages: [ { role: "user", content: "rephrase text as " + process.argv.slice(1).join(" ")  + ". text:" + lines.join("\n") } ] };
    console.log(JSON.stringify(prompt));
  })();
  ' ${*} \
    | curl -s https://api.openai.com/v1/chat/completions  -H "Content-Type: application/json" -H "Authorization: Bearer $OPENAI_API_KEY" -d @- \
    | fx 'x => x.choices[0].message.content'
}

function mvr(){ #vidir
  local cnt=0
  while IFS= read -r line; do cnt=$((cnt+1)); printf "%04d\t%s\n" $cnt $line; done | tee /tmp/mvr.in > /tmp/mvr.out
  nvim /tmp/mvr.out
  join -a 1 /tmp/mvr.in /tmp/mvr.out | awk '{
    if ($2==$3){next;}
    if (!$3){print "rm -rf "$2; next;}
    print "mv "$2" "$3;
  }' | sh
  rm -rf /tmp/mvr.in /tmp/mvr.out
}

