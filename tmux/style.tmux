#### COLOUR (Solarized dark)

# default statusbar colors
set-option -g status-style bg=black,fg=yellow

# default window title colors
set-window-option -g window-status-style fg=brightblue,bg=default

# active window title colors
set-window-option -g window-status-current-style fg=brightred,bg=default

# pane border
set-option -g pane-border-style fg=black
set-option -g pane-active-border-style fg=black

# message text
set-option -g message-style bg=black,fg=brightred

# pane number display
set-option -g display-panes-active-colour blue #blue
set-option -g display-panes-colour brightred #orange

# clock
set-window-option -g clock-mode-colour green #green

# bell
set-window-option -g window-status-bell-style fg=black,bg=red


#### title

#### STATUS LINE

set -g status-left-length 100
set -g status-right-length 100

set -g status-left '#[fg=black,bg=green] #($func/username) #[fg=cyan,bg=blue]#[fg=colour0,bg=blue] #($func/hostname) #[fg=blue,bg=black] #[fg=colour15,bg=colour0] #{pane_current_path} #[fg=colour10,bg=colour0] #($func/gitbranch #{pane_current_path}) #[default] '
set -g status-right '#[fg=cyan,bg=black]'

set -g window-status-separator ''

set-window-option -g window-status-bell-style 'fg=red,blink,bg=default'
set-window-option -g window-status-activity-style 'fg=red,blink,bg=default'
set-window-option -g window-status-format '#[fg=black,bg=white] #I:#{=15:window_name}#{?window_bell_flag,!,} #[fg=colour10,bg=default]#[black] '
set-window-option -g window-status-current-format '#[fg=black,bg=cyan] #[fg=black,bg=cyan]#I:#W #[fg=cyan,bg=default]#[default] '
set -g status-justify right
