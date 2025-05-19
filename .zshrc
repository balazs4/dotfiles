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
#mcbpro export PATH="/Applications/SnowSQL.app/Contents/MacOS:$PATH"
#mcbpro export DOCKER_HOST=unix://${HOME}/.colima/default/docker.sock
#mcbpro function thinkdifferent() {
#mcbpro   find /Applications -name '*.app' \
#mcbpro     | fzf \
#mcbpro     | xargs -t -I{} xattr -d com.apple.quarantine {}
#mcbpro }
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
function zle-line-init zle-keymap-select {
  test $COLUMNS -lt 80 && NEWLINE=$'\n' || NEWLINE=''
  PROMPT="%B%F{#{{base07-hex}}} %~%f%b$(zsh-git &) %B%F{#{{base07-hex}}}${NEWLINE}»%f%b "
  RPROMPT="%(?.%F{#{{base07-hex}}}.%F{red})%?%f `[[ $KEYMAP == 'vicmd' ]] && echo '[normal]'`"
  if test ${SSH_CLIENT}; then
    PROMPT="[%m] ${PROMPT}"
  fi
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1

function TRAPUSR1(){
  source $HOME/.zshrc
  source $HOME/.zshenv
}

function zz() {
  local to=`{
    echo $HOME/.files;
    find $HOME/src -maxdepth 1 -type d;
#mcbpro    find $HOME/src/api -maxdepth 2 -type d;
#mcbpro    find $HOME/src/front/apps -maxdepth 1 -type d;
  } | fzf --layout=reverse --height '40%' -q "${*:-$PWD} " -1`

  [[ $TMUX ]] \
    && cd ${to:-$PWD} \
    || tmux new-session -A -s ${to:-$PWD} -c ${to:-$PWD}
}

alias z='TMUX=fake zz'
alias x='tmux new-session -A -s $HOME -c $HOME'

#golang - https://github.com/stefanmaric/g
export GOROOT=$HOME/.g
export GOPATH=$HOME/.go
export PATH=${GOROOT}:${GOPATH}/bin:${PATH}

# fzf
export PATH=$HOME/.fzf:${PATH}
source $HOME/.fzf/completion.zsh
source $HOME/.fzf/key-bindings.zsh
export FZF_DEFAULT_COMMAND="git ls-files || find . -type f -maxdepth 4"
export FZF_CTRL_T_COMMAND="git ls-files || find . -type f -maxdepth 4"
export FZF_DEFAULT_OPTS="--no-separator --bind 'ctrl-x:execute-silent(echo {} | xurls | xargs xdg-open)'"

function _fzf(){
  rm -rf $HOME/.fzf/ 2>/dev/null
  mkdir -p $HOME/.fzf/ 2>/dev/null
#mcbpro  os="darwin"
#mcbpro  arch="arm64"
  curl -LSs 'https://api.github.com/repos/junegunn/fzf/releases/latest?page=1&per_page=1' \
    | fx 'x => x.assets.map(xx => [xx.created_at, xx.browser_download_url].join("\t")).join("\n")' \
    | grep "${os:-linux}" \
    | grep "${arch:-amd64}" \
    | grep -v sha \
    | vipe \
    | xurls \
    | xargs curl -LSso - \
    | tar xzv -C $HOME/.fzf

  tag_name="v$(fzf --version | awk '{print $1}')"

  curl -LSs "https://github.com/junegunn/fzf/blob/$tag_name/shell/completion.zsh?raw=true"    --output "$HOME/.fzf/completion.zsh"
  curl -LSs "https://github.com/junegunn/fzf/blob/$tag_name/shell/key-bindings.zsh?raw=true"  --output "$HOME/.fzf/key-bindings.zsh"

  mkdir -p $HOME/.fzf/plugin 2>/dev/null
  curl -LSs "https://github.com/junegunn/fzf/blob/$tag_name/plugin/fzf.vim?raw=true"          --output "$HOME/.fzf/plugin/fzf.vim"

  mkdir -p $HOME/.fzf/man/man1/ 2>/dev/null
  curl -LSs "https://github.com/junegunn/fzf/blob/$tag_name/man/man1/fzf.1?raw=true"          --output "$HOME/.fzf/man/man1/fzf.1"

  fzf --version
}

function _fx(){
  GOPROXY= go install github.com/antonmedv/fx@latest
}

if test $TMUX
then
  export TERM=tmux-256color
else
  export TERM=xterm-256color
fi

export LANG=en_US.UTF-8
export TERMINAL=alacritty
export BROWSER=xdg-open
#carbon export BROWSER=qutebrowser
export GPG_TTY=`tty`
export RIPGREP_CONFIG_PATH=$HOME/.rgrc
export PATH=$HOME/.local/bin:${PATH}

#node.js - https://github.com/tj/n
export N_PREFIX=$HOME/.n/prefix
export N_PRESERVE_NPM=1
export PATH=$HOME/.n:$N_PREFIX/bin:${PATH}
export NPM_CONFIG_LOGLEVEL=http
export DOTENV_CONFIG_DEBUG=true
#mcbpro export PNPM_HOME=$HOME/.pnpm

#lua
export PATH=$HOME/.lua/bin:${PATH}
function _lua(){
#mcbpro   os=darwin
  rm -rf $HOME/.lua/ 2>/dev/null
  mkdir -p $HOME/.lua/ 2>/dev/null
  curl -Lis 'https://api.github.com/repos/LuaLS/lua-language-server/releases/latest?page=1&per_page=1' \
    | stdsplit \
    | fx 'x => x.assets.map(xx => [xx.created_at, xx.browser_download_url].join("\t")).join("\n")' \
    | grep -v sha \
    | fzf -q "${os:-linux}" -1 \
    | xurls \
    | xargs curl -Lo - \
    | tar xzv  -C $HOME/.lua
  lua-language-server --version
}

#bun
export PATH="$HOME/.bun/bin:${PATH}"
export DO_NOT_TRACK=1

#deno
export PATH="$HOME/.deno/bin:${PATH}"

#rust
#mcbpro export PATH="$HOME/.cargo/bin:${PATH}"

#neovim
export PATH="$HOME/.nvim/bin:${PATH}"
export EDITOR=nvim
export MANPAGER='nvim +Man!' #https://www.visualmode.dev/a-better-man-page-viewer

function _nvim(){
#mcbpro  os="macos 'tar.gz 'arm64"
  rm -rf $HOME/.nvim/ 2>/dev/null
  mkdir -p $HOME/.nvim/ 2>/dev/null
  curl 'https://api.github.com/repos/neovim/neovim/releases/tags/nightly?page=1&per_page=1' \
    | fx 'x => x.assets.map(xx => [xx.created_at, xx.browser_download_url].join("\t")).join("\n")' \
    | grep -v sha \
    | fzf -q "${os:-linux 'tar.gz 'x86_64}" -1 \
    | xurls \
    | xargs curl -Lo - \
    | tar xzv --strip-components=1 -C $HOME/.nvim
  nvim --version
}

#carbon #curl https://ziglang.org/download/0.13.0/zig-linux-x86_64-0.13.0.tar.xz  | tar xv -J -C $HOME/.zig --strip-components=1
#mcbpro #curl https://ziglang.org/download/0.13.0/zig-macos-aarch64-0.13.0.tar.xz | tar xv -J -C $HOME/.zig --strip-components=1
export PATH="$HOME/.zig:${PATH}"

#emmet
#carbon #curl https://gitlab.com/balazs4/emmet/-/releases/2024-10-03-5811a53e/downloads/emmet-x86_64-linux.tar.gz -L   | tar xvz -C $HOME/.local/bin
#mcbpro #curl https://gitlab.com/balazs4/emmet/-/releases/2024-10-03-5811a53e/downloads/emmet-aarch64-darwin.tar.gz -L | tar xvz -C $HOME/.local/bin

function dotedit() {
  pushd $HOME/.files 1>/dev/null 2>/dev/null
  target=$({git ls-files; printf '%s\n' 'all' 'sync';} | fzf -1 -q "'${*}")
  if test "$EDITOR"; then $EDITOR ${target}; fi
  make --always-make ${target}
  popd 1>/dev/null 2>/dev/null
}
alias dot='EDITOR= dotedit'
alias tmuxrc='dotedit .tmux.conf'
alias zshrc='dotedit .zshrc'
alias nvimrc='dotedit .config/nvim/init.lua'
#carbon alias sx='dotedit .xbindkeysrc'
alias so='vim $HOME/.zshenv; source $HOME/.zshenv'

alias wttr="curl -H 'cache-control: no-cache' -s 'http://wttr.in/91085?format=3'"
alias ls='ls --color=auto'
alias grep='grep --color'
alias :q='exit'
alias :q!='exit'
alias ll='ls -hal'
alias rm='rm -i'
alias yolo='git add . && git commit -m "yolo" --no-verify && git push --no-verify || true'
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
alias wipe-af='docker system prune -a -f'
alias dco='docker compose'
alias rg='rg --hidden'
alias dmesg='sudo dmesg'
alias cal='LC_ALL=de_DE.utf8 cal'
#carbon alias yay='yay --editmenu'
#mcbpro alias awk='gawk'
#mcbpro alias sed='gsed'
#mcbpro alias xargs='gxargs'
alias less='less -r'
#carbon alias xx='xclip -rmlastnl -selection clipboard'
#mcbpro alias xx='pbcopy'


function srdrop(){
  if test "${1:-nothing}" = "reload"
  then
    deno cache --reload https://gitlab.com/balazs4/srdrop/-/raw/main/main.js
  fi
  deno run --allow-net --allow-sys --allow-write --allow-read https://gitlab.com/balazs4/srdrop/-/raw/main/main.js
}

function heic(){
  filename=`cat -`
  magick convert "${filename}" -resize 50% "${filename}.jpg"
  printf "$filename\n$filename.jpg\n"
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

function track(){
  test -e $HOME/.cache/spotify || {
    local url="https://accounts.spotify.com/authorize?client_id=${SPOTIFY_CLIENT_ID}&response_type=code&redirect_uri=http://localhost:8000/&scope=playlist-modify-public"
    xdg-open $url
    local spotify_code=`node -e "
    require('node:http').createServer((req, res) => {
      res.end('you can close this tab');
      const code = new URL('http://localhost:8000' + req.url).searchParams.get('code');
      console.log(code);
      process.exit(0);
    }).listen(8000);"`

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
  make -C $HOME/.files .config/i3/config
  i3-msg restart
}

function aws-on(){
  export `pass ${PASSKEY:-aws/balazs4} | awk '/^AWS_/ {print $0}'`
}

function aws-off(){
  unset `env | awk -F= '/^AWS_/ {print $1 }'`
}

function yt(){
  if test $TMUX
  then
    local target=`tmux display-message -p '#I'`
    tmux rename-window -t:$target youtube
  fi

  echo ${*:-$(cat -)} \
    | tr ' ' '+' \
    | xargs -t -I{} curl -Lfs -H "accept-language: ${LNG:-en}" https://www.youtube.com/results\?search_query={} \
    | pup 'script:contains("var ytInitialData") text{}' \
    | sed 's/var ytInitialData = //g; s/};/}/' \
    | bun -e '
      (async() => {
        const lines = [];
        for await (const line of require("node:readline").createInterface(process.stdin)) {
          lines.push(line);
        }
        const yt = JSON.parse(lines.join("\n"));

        for (const x of yt.contents.twoColumnSearchResultsRenderer.primaryContents.sectionListRenderer.contents) {
          if (!x) continue;
          if (!x.itemSectionRenderer) continue;
          if (!x.itemSectionRenderer.contents) continue;

          for (const xx of x.itemSectionRenderer.contents){
            if (!xx) continue;
            if (!xx.videoRenderer) continue;
            const video = [
              xx.videoRenderer.thumbnail?.thumbnails[0].url,
              xx.videoRenderer.videoId,
              xx.videoRenderer.lengthText?.simpleText.padStart(8),
              (xx.videoRenderer.viewCountText?.simpleText || "premier at").padStart(16),
              (xx.videoRenderer.publishedTimeText?.simpleText || new Date(1000 * parseInt(xx.videoRenderer.upcomingEventData?.startTime || "0")).toJSON() ).padStart(24),
              xx.videoRenderer.title.runs[0].text,
            ].join("\t")
            require("node:process").stdout.write(video + "\n")
          }
        }
      })();' \
    | fzf --sync --height=50% --with-nth=2.. --delimiter="\t" --preview-window 'right,40%' --preview='wget {1} -O- 2>/dev/null | chafa --scale 2.0 -' \
    | cut -f2 \
    | xargs -t -Iwatch mpv ${MPV:---ytdl-raw-options=format-sort='res:1080'} https://youtu.be/watch
}
alias yta="MPV='--ytdl-raw-options=format=bestaudio' yt"


function pihole(){
  curl -Lis http://192.168.178.42:9000/admin/api.php | $HOME/.local/bin/stdsplit
}


function qrdecode {
  shotgun `hacksaw -f '-i %i -g %g'` - | zbarimg -q --raw -
}

function archnews(){
  curl -s https://archlinux.org/feeds/news/ \
    | fxparser \
    | fx 'x => x.rss.channel.item.map(xx => [`\x1b[2m${xx.link}\x1b[0m`, new Date(xx.pubDate).toJSON() + ` >> \x1b[1m${xx.title}\x1b[0m`, " "].join("\n")).join("\n")'
}

#carbon function dp1(){
#carbon   xrandr \
#carbon     --dpi 136 \
#carbon     --output eDP1 --primary --mode 1920x1080 --pos 800x2160 --rotate normal --scale 1.4 \
#carbon     --output DP2 --off \
#carbon     --output DP1 --mode 3840x2160 --pos 0x0 --rotate normal \
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

function gb(){
  git branch -a \
    | grep -v HEAD \
    | fzf -1 -q "'${*} " \
    | sed 's|remotes/origin/||g;s|^*||g' \
    | xargs -t git checkout
}

alias gbb='gb $USER'

alias .env='set -o allexport; source .env; set +o allexport'

function nr() {
  fx package.json 'x => Object.entries(x.scripts).map(xx => [xx[0].padEnd(16), xx[1]].join("\t")).join("\n")' \
    | fzf --height 10% --reverse -q"'${*}" -1 \
    | awk '{print $1}' \
    | xargs -I{} -t npm run {}
}

#mcbpro export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
#mcbpro export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"
#mcbpro export BUILD_LIBRDKAFKA=0

#carbon function cool(){
#carbon   echo level ${1:-7} | sudo tee /proc/acpi/ibm/fan
#carbon }

#mcbpro function ip() {
#mcbpro   dig $1 | awk "/^$1/ {print \$NF}"
#mcbpro }

function countby(){
   awk '{a[$1]++;} END{for(i in a) print i"  "a[i]}' | sort -k2 -r -h
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

#mcbpro function na(){
#mcbpro   n auto
#mcbpro   grep private $HOME/.npmrc > /dev/null || $HOME/.local/bin/npmrc
#mcbpro   pnpm install ${*:---frozen-lockfile}
#mcbpro }

alias stars="xdg-open 'https://github.com/balazs4?tab=stars'"

#carbon alias xb='xbacklight -set'

function color(){
  if test ! -d $HOME/.cache/schemes; then git clone git@github.com:tinted-theming/schemes.git $HOME/.cache/schemes --depth=1; fi
  colors=$(git -C $HOME/.cache/schemes ls-files | sort | fzf --no-sort --reverse -q"'yaml ${*} " -1 --preview 'make -C $HOME/.files .config/.colors/index.html colors_file=$HOME/.cache/schemes/{}; cat $HOME/.cache/schemes/{}')
  cp $HOME/.cache/schemes/$colors $HOME/.colors
  make -C $HOME/.files ${PREVIEW}
  if test ${PREVIEW}
  then
    pgrep -a qutebrowser 1>/dev/null 2>/dev/null && qutebrowser ':set colors.webpage.darkmode.enabled false'
  fi
}

function dark(){
  color ${*}
#mcbpro   osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = true" > /dev/null
}

function light(){
  color ${*}
#mcbpro   osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = false" > /dev/null
}

function parrot(){
  curl --max-time ${1:-3} parrot.live 2>/dev/null
}

function a(){
#carbon  picom --daemon --backend xrender 2> /dev/null
 opacity=$(bc <<< "scale=2; x=$1/100; if(x<1) print 0; x")
 sed "s/^opacity = .*/opacity = ${opacity}/" -i "$HOME/.alacritty.toml"
}

#carbon function nyc(){
#carbon   if test ! -f "$HOME/.cache/macos_newyork.webm"; then yt-dlp "https://www.youtube.com/watch?v=Gx6NVCRyMzk" -o "$HOME/.cache/macos_newyork.webm"; fi
#carbon   mpv "$HOME/.cache/macos_newyork.webm" --no-audio --frames=1 --start=+$(($RANDOM % 236)) -o "$HOME/.cache/macos_newyork.png" 
#carbon   feh --no-fehbg --bg-fill "$HOME/.cache/macos_newyork.png"
#carbon }

#mcbpro function dog(){
#mcbpro   local service=`git -C $HOME/src/api ls-files | grep services | grep package.json | awk -F/ '{print $2}' | fzf -1 --height '25%' -q"${*}"`
#mcbpro   open "https://app.datadoghq.com/logs/livetail?query=service%3A${service}%20&cols=host%2Cservice&index=%2A&messageDisplay=inline&refresh_mode=sliding&storage=live&stream_sort=desc&view=spans&viz=stream&live=true"
#mcbpro }

export BUILDKIT_PROGRESS=plain

#carbon function eth0() {
#carbon   case ${1:-help} in
#carbon 
#carbon     "up")
#carbon       sudo ip link set wlan0 down
#carbon       sleep 1
#carbon       sudo ip link set enp0s31f6 up
#carbon       sleep 1
#carbon       sudo systemctl start dhcpcd.service
#carbon       ;;
#carbon 
#carbon     "down")
#carbon       sudo systemctl stop dhcpcd.service
#carbon       sleep 1
#carbon       sudo ip link set enp0s31f6 down
#carbon       sleep 1
#carbon       sudo ip link set wlan0 up
#carbon       ;;
#carbon 
#carbon     *)
#carbon       printf "eth0 up | down\n"
#carbon       ;;
#carbon   esac
#carbon }

#carbon function mask(){
#carbon   #https://unix.stackexchange.com/a/734842
#carbon   for F in $(awk '$4=="unmasked" && $1>1000{print FILENAME}' /sys/firmware/acpi/interrupts/*)
#carbon   do
#carbon     echo $F >&2
#carbon     sudo tee $F <<<mask;
#carbon   done
#carbon }

function focus(){
  mpv --no-video https://youtu.be/GUu8GW6H5Dw
}

#mcbpro function colima_start(){
#mcbpro   # TODO: $HOME/.colima/default/colima.yaml
#mcbpro   colima start --cpu 10 --memory 8 --disk 128 --arch aarch64 --vm-type=vz --vz-rosetta  --network-address
#mcbpro }

function re(){
  nvim $(gh pr diff --name-only)
}

#mcbpro function duration(){
#mcbpro   datediff $(cat $1 | head -1 | awk '{print $1}') $(cat $1 | tail -1 | awk '{print $1}')
#mcbpro }

#https://mac-key-repeat.zaymon.dev/
#mcbpro defaults write -g InitialKeyRepeat -int 12
#mcbpro defaults write -g KeyRepeat -int 2

function rfc(){
  test $TMUX && {
    local target=`tmux display-message -p '#I'`
    tmux rename-window -t:$target rfc-${1}
  }
  curl -s "https://www.rfc-editor.org/rfc/rfc${1}.txt" | less -R
}

alias sp='spotify_player'
alias spp='spotify_player playback play-pause'
alias spn='spotify_player playback next'
alias spz='source <(spotify_player generate zsh)'
function sps() {
  spotify_player search "$*" \
    | fx 'x => [
      ...x.artists.map(  xx => ["0000-00-00",    xx.id, "artist".padEnd(8), xx.name].join("\t")),
      ...x.playlists.map(xx => ["0000-00-00",    xx.id, "playlist",         xx.name].join("\t")),
      ...x.albums.map(   xx => [xx.release_date, xx.id, "album".padEnd(8),  xx.name].join("\t")),
      ].join("\n")' \
    | sort -r  \
    | fzf --height=25% --reverse \
    | tee /dev/stderr \
    | awk '{printf "playback start context %s --id=%s", $3, $2}' \
    | xargs spotify_player
}

function s() {
  input=${*:-$(cat -)}
  search_term=$(echo "${input}" | tr ' ' '+')
  url="https://start.duckduckgo.com/lite/?q=${search_term}"
  curl -A "aun3Modeitoa9eequ2quooph7yoh4ohn" -D /dev/stderr -Ls "${url}" \
    | tee /tmp/s.html \
    | sed "s|\(<span class='link-text'>\)|\1https://|g" \
    | pup 'table' \
    | w3m -dump -T text/html -cols $COLUMNS \
    | awk '
  /    https:\/\// {print "\033[1m"$0"\033[0m\n"; next;} 
  /^[0-9]+\./ {print "\033[33;1m"$0"\033[0m";next;} 
  /\[Next Page / {next;}
  1 {print $0;}
  '

  printf "%s\t" $url "https://start.duckduckgo.com/html/?q=${search_term}" "https://start.duckduckgo.com/?q=${search_term}"
  printf "\n"
}

#mcbpro alias linear='make -f $HOME/src/linear/makefile'

#mcbpro function dpl() {
#mcbpro   input=${1:-`cat -`}
#mcbpro   chunk=$(printf '%s' $input | gawk -F/ '{print $NF}')
#mcbpro   if test -z "${chunk}"; then chunk=${input}; fi
#mcbpro   printf "%s\n" \
#mcbpro     "${VC_ADMIN_DPL}/${chunk}" \
#mcbpro     "${VC_ADMIN_DPL}/dpl_${chunk}" \
#mcbpro     | fzf -1 -q '!dpl_dpl_ dpl_' \
#mcbpro     | xargs xdg-open
#mcbpro }


#mcbpro function slack() {
#mcbpro   # fu hdr!
#mcbpro   killall -9 Slack;
#mcbpro   sleep 2;
#mcbpro   open /Applications/Slack.app/ --args --force-color-profile=srgb
#mcbpro }


#carbon function say() {
#carbon   dunstify "$(cat -)"
#carbon }

function sich() {
  curl https://raw.githubusercontent.com/bezufache/Betonieren/refs/heads/master/README.md -s \
    | grep '* Sich' \
    | tr -d '*' \
    | shuf \
    | head -1 \
    | tee /dev/stderr \
    | say -v Anna -f -
}
