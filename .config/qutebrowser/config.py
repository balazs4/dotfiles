import time
import threading

config.load_autoconfig(False); # ignore autoconfig because mcbpro

c.colors.webpage.darkmode.policy.images = 'never'
c.colors.webpage.preferred_color_scheme = '{{variant}}'

if c.colors.webpage.preferred_color_scheme == 'light':
    c.colors.webpage.darkmode.enabled = False
else:
    c.colors.webpage.darkmode.enabled = True

c.url.default_page = 'about:blank'
c.url.start_pages = 'qute://version'

c.url.searchengines = {
    'DEFAULT':  'https://start.duckduckgo.com/lite/?q={}',
    '!d':       'https://start.duckduckgo.com/?q={}',
    '!dh':      'https://start.duckduckgo.com/html/?q={}',
    '!g':       'https://google.com/?q={}',
    '!dw':      'https://de.wiktionary.org/wiki/{}',
    '!gh':      'https://github.com/search?o=desc&q={}&s=stars',
    '!r':       'https://old.reddit.com/search?q={}',
    '!yt':      'https://www.youtube.com/results?search_query={}'
}

c.content.blocking.method = 'both'
c.completion.open_categories = ["searchengines", "quickmarks"]

config.bind(',m', 'hint links spawn --detach mpv {hint-url} --ytdl-raw-options=format-sort="res:720" --pause --cache-pause-initial=yes')
config.bind(',d', 'set colors.webpage.darkmode.enabled true')
config.bind(',l', 'set colors.webpage.darkmode.enabled false')
config.bind(',L', 'set colors.webpage.preferred_color_scheme light')
config.bind(',D', 'set colors.webpage.preferred_color_scheme dark')
config.bind('\\\\', 'cmd-set-text :open -t !')


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

#mcbpro c.fonts.default_family = "Geist Mono"
#mcbpro c.fonts.default_size = "14pt"

c.fonts.tabs.selected = '900 default_size default_family'
c.fonts.tabs.unselected = '500 default_size default_family'

c.tabs.favicons.show = 'never'

config.set('input.mode_override', 'passthrough', 'https://web.whatsapp.com');

#mcbpro c.window.hide_decoration = False
#mcbpro def thinkdifferent():
#mcbpro     time.sleep(1)
#mcbpro     c.window.hide_decoration = True
#mcbpro 
#mcbpro threading.Thread(target = thinkdifferent, args=[]).start()
