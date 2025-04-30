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
    '!dw':      'https://de.wiktionary.org/wiki/{}',
    '!gh':      'https://github.com/search?o=desc&q={}&s=stars',
    '!gist':    'https://gist.github.com/search?q={}',
    '!r':       'https://old.reddit.com/search?q={}',
    '!yt':      'https://www.youtube.com/results?search_query={}'
}

config.bind(',m', 'hint links spawn --detach mpv {hint-url} --ytdl-raw-options=format-sort="res:720" --pause --cache-pause-initial=yes')

#mcbpro c.window.hide_decoration = True
#mcbpro c.fonts.completion.category = '15pt'
#mcbpro c.fonts.completion.entry = '15pt'
#mcbpro c.fonts.debug_console = '15pt'
#mcbpro c.fonts.downloads = '15pt'
#mcbpro c.fonts.hints = '15pt'
#mcbpro c.fonts.keyhint = '15pt'
#mcbpro c.fonts.messages.error = '15pt'
#mcbpro c.fonts.messages.info = '15pt'
#mcbpro c.fonts.messages.warning = '15pt'
#mcbpro c.fonts.prompts = '15pt'
#mcbpro c.fonts.statusbar = '15pt'
#mcbpro c.fonts.tabs.selected = '15pt'
#mcbpro c.fonts.tabs.unselected = '15pt'
#mcbpro c.qt.highdpi = True
#mcbpro c.fonts.default_family = "GeistMono Nerd Font"
