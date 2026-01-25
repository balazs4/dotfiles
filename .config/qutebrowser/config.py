import time
import threading

config.load_autoconfig(True);

c.colors.webpage.darkmode.policy.images = 'never'
c.colors.webpage.preferred_color_scheme = 'auto'

c.url.default_page = 'about:blank'
c.url.start_pages = 'qute://version'

c.url.searchengines = {
    'DEFAULT':  'https://start.duckduckgo.com/lite/?q={}',
    '!aw':      'https://wiki.archlinux.org/index.php?search={}',
    '!d':       'https://start.duckduckgo.com/lite/?q={}',
    '!dd':      'https://start.duckduckgo.com/html/?q={}',
    '!ddg':     'https://start.duckduckgo.com/?q={}',
    '!g':       'https://google.com/search?q={}',
    '!dw':      'https://de.wiktionary.org/wiki/{}',
    '!gh':      'https://github.com/search?o=desc&q={}&s=stars',
    '!r':       'https://old.reddit.com/search?q={}',
    '!yt':      'https://www.youtube.com/results?search_query={}'
}

c.content.blocking.method = 'both'
c.content.pdfjs = True
c.completion.open_categories = ["searchengines", "quickmarks"]

config.bind(',m', 'spawn --detach mpv {url} --ytdl-raw-options=format-sort="res:720" --pause --cache-pause-initial=yes')
config.bind(',M', 'hint links spawn --detach mpv {hint-url} --ytdl-raw-options=format-sort="res:720" --pause --cache-pause-initial=yes')
config.bind(',,', 'set colors.webpage.darkmode.enabled true')
config.bind(',.', 'set colors.webpage.darkmode.enabled false')
config.bind(',z', 'set tabs.show never')
config.bind(',Z', 'set tabs.show always')


c.colors.completion.fg = "#{{base05-hex}}"
c.colors.completion.odd.bg = "#{{base01-hex}}"
c.colors.completion.even.bg = "#{{base00-hex}}"
c.colors.completion.category.fg = "#{{base0A-hex}}"
c.colors.completion.category.bg = "#{{base00-hex}}"
c.colors.completion.category.border.top = "#{{base00-hex}}"
c.colors.completion.category.border.bottom = "#{{base00-hex}}"
c.colors.completion.item.selected.fg = "#{{base05-hex}}"
c.colors.completion.item.selected.bg = "#{{base02-hex}}"
c.colors.completion.item.selected.border.top = "#{{base02-hex}}"
c.colors.completion.item.selected.border.bottom = "#{{base02-hex}}"
c.colors.completion.item.selected.match.fg = "#{{base09-hex}}"
c.colors.completion.match.fg = "#{{base09-hex}}"
c.colors.tabs.bar.bg = "#333333"
c.colors.tabs.even.bg = "#333333"
c.colors.tabs.odd.bg = "#333333"
c.colors.tabs.selected.even.bg = "#000000"
c.colors.tabs.selected.odd.bg = "#000000"

c.colors.tabs.even.fg = "#999999"
c.colors.tabs.odd.fg = "#999999"
c.colors.tabs.selected.even.fg = "#ffffff"
c.colors.tabs.selected.odd.fg = "#ffffff"

#aspire c.fonts.default_size = "12pt"

c.fonts.tabs.selected = '900 default_size default_family'
c.fonts.tabs.unselected = '500 default_size default_family'

c.tabs.favicons.show = 'never'
c.tabs.show = 'always'
c.tabs.position = 'right'
