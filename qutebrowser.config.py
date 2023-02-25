config.load_autoconfig(False)

# c.qt.highdpi = True
c.colors.webpage.bg = "black"
# c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.threshold.background = 205

c.fonts.completion.category = 'bold 12pt monospace'
c.fonts.completion.entry = '12pt monospace'
c.fonts.statusbar = '12pt monospace'
c.fonts.tabs.selected = '12pt monospace'
c.fonts.tabs.unselected = '12pt monospace'
c.fonts.contextmenu = '12pt monospace'
c.qt.args=["blink-settings=darkMode=4"]

c.content.cookies.accept = 'no-3rdparty'
c.content.headers.user_agent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36'
c.content.headers.accept_language = "ja-JP,js;q=0.9"
c.url.searchengines = { "DEFAULT" : "https://searx.info/search?q={}" }

# c.content.user_stylesheets = "~/software/solarized-everything-css/css/apprentice/apprentice-all-sites.css"
# config.bind(',ap', 'config-cycle content.user_stylesheets ~/software/solarized-everything-css/css/apprentice/apprentice-all-sites.css ""')
# config.bind(',dr', 'config-cycle content.user_stylesheets ~/software/solarized-everything-css/css/darculized/darculized-all-sites.css ""')
# config.bind(',gr', 'config-cycle content.user_stylesheets ~/software/solarized-everything-css/css/gruvbox/gruvbox-all-sites.css ""')
# config.bind(',sd', 'config-cycle content.user_stylesheets ~/software/solarized-everything-css/css/solarized-dark/solarized-dark-all-sites.css ""')
# config.bind(',sl', 'config-cycle content.user_stylesheets ~/software/solarized-everything-css/css/solarized-light/solarized-light-all-sites.css ""')

c.zoom.default = '80%'
c.url.default_page = 'https://searx.info'
c.url.start_pages = ['https://searx.info']
c.tabs.background = True

c.colors.webpage.preferred_color_scheme = 'dark'
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.colors.webpage.darkmode.contrast = 0.0
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.grayscale.all = False
c.colors.webpage.darkmode.grayscale.images = 0.0
c.colors.webpage.darkmode.policy.images = 'smart'
c.colors.webpage.darkmode.policy.page = 'smart'
c.colors.webpage.darkmode.threshold.background = 128
c.colors.webpage.darkmode.threshold.text = 128

c.qt.args = ['disable-seccomp-filter-sandbox']


# config.source('/home/bumble/software/guix-home/qutebrowser.theme.gruvbox.dark.py')
config.source('qutebrowser.theme.city-lights.py')
