# .carbon

export NPM_CONFIG_PREFIX=$HOME/.npm_global
export PATH=$NPM_CONFIG_PREFIX/bin:$PATH

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

alias blueon='sudo systemctl start bluetooth.service && bluetoothctl power on && bluetoothctl connect 17:50:01:B0:02:71'
alias blueoff='bluetoothctl power off && sudo systemctl start bluetooth.service'
alias vercel='npx -q vercel -t $VERCEL_TOKEN'
alias vc='npx -q vercel -t $VERCEL_TOKEN'
alias now='npx -q vercel -t $VERCEL_TOKEN'
# webapps
alias whatsapp='google-chrome-stable --user-data-dir=$HOME/.config/webapp/whatsapp --app=https://web.whatsapp.com'
alias outlook='microsoft-edge-dev --user-data-dir=$HOME/.config/webapp/microsoft --app=https://outlook.com'
alias spotify='google-chrome-stable --user-data-dir=$HOME/.config/webapp/spotify --app=https://open.spotify.com/'
alias shop='google-chrome-stable --user-data-dir=$HOME/.config/webapp/shop'
alias bank='google-chrome-stable --user-data-dir=$HOME/.config/webapp/bank'
alias google='google-chrome-stable --user-data-dir=$HOME/.config/webapp/google'
alias teams='microsoft-edge-dev --user-data-dir=$HOME/.config/webapp/microsoft365 https://teams.microsoft.com'
