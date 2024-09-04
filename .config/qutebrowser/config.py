import os

# Define Colemak keybindings
config.load_autoconfig()
c = config

c.bind('n', 'cmd-run-with-count 5 :scroll down')
c.bind('e', 'cmd-run-with-count 5 :scroll up')
c.bind('N', 'cmd-run-with-count 10 :scroll down')
c.bind('E', 'cmd-run-with-count 10 :scroll up')


c.bind('i', 'cmd-run-with-count 3 :scroll right')

c.bind('I', ':tab-next')
c.bind('H', ':tab-prev')

c.bind('u', ':back')
c.bind('U', ':forward')
c.bind('xs', 'config-cycle --temp --print --pattern *://*.{url:host}/* content.javascript.enabled ;; reload')
# Other Qutebrowser settings
# ...


# Configure other settings as needed
