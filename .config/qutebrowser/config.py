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

config.bind('<Ctrl+/>', 'hint links spawn --detach mpv {hint-url}')
