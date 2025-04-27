config.load_autoconfig();

c.url.searchengines = {
    'DEFAULT':  'https://start.duckduckgo.com/html/?q={}',
    '!d':       'https://start.duckduckgo.com/?q={}',
    '!dw':      'https://thefreedictionary.com/{}',
    '!gh':      'https://github.com/search?o=desc&q={}&s=stars',
    '!gist':    'https://gist.github.com/search?q={}',
    '!r':       'https://old.reddit.com/search?q={}',
    '!w':       'https://en.wikipedia.org/wiki/{}',
    '!yt':      'https://www.youtube.com/results?search_query={}'
}

config.bind(',m', 'hint links spawn --detach mpv {hint-url} --ytdl-raw-options=format-sort="res:720" --pause --cache-pause-initial=yes')

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
#mbcpro c.qt.highdpi = true
#mcbpro c.fonts.default_family = "GeistMono Nerd Font"

# origin: https://github.com/theova/base16-qutebrowser
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
c.colors.completion.item.selected.match.fg = "#{{base0B-hex}}"
c.colors.completion.match.fg = "#{{base0B-hex}}"
c.colors.prompts.fg = "#{{base05-hex}}"
c.colors.prompts.border = "#{{base00-hex}}"
c.colors.prompts.bg = "#{{base00-hex}}"
c.colors.prompts.selected.bg = "#{{base02-hex}}"
c.colors.prompts.selected.fg = "#{{base05-hex}}"
c.colors.tabs.bar.bg = "#{{base00-hex}}"
c.colors.tabs.indicator.start = "#{{base0D-hex}}"
c.colors.tabs.indicator.stop = "#{{base0C-hex}}"
c.colors.tabs.indicator.error = "#{{base08-hex}}"
c.colors.tabs.odd.fg = "#{{base05-hex}}"
c.colors.tabs.odd.bg = "#{{base01-hex}}"
c.colors.tabs.even.fg = "#{{base05-hex}}"
c.colors.tabs.even.bg = "#{{base00-hex}}"
c.colors.tabs.pinned.even.bg = "#{{base0C-hex}}"
c.colors.tabs.pinned.even.fg = "#{{base07-hex}}"
c.colors.tabs.pinned.odd.bg = "#{{base0B-hex}}"
c.colors.tabs.pinned.odd.fg = "#{{base07-hex}}"
c.colors.tabs.pinned.selected.even.bg = "#{{base02-hex}}"
c.colors.tabs.pinned.selected.even.fg = "#{{base05-hex}}"
c.colors.tabs.pinned.selected.odd.bg = "#{{base02-hex}}"
c.colors.tabs.pinned.selected.odd.fg = "#{{base05-hex}}"
c.colors.tabs.selected.odd.fg = "#{{base05-hex}}"
c.colors.tabs.selected.odd.bg = "#{{base02-hex}}"
c.colors.tabs.selected.even.fg = "#{{base05-hex}}"
c.colors.tabs.selected.even.bg = "#{{base02-hex}}"
