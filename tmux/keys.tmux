# Prefix
set-option -g prefix C-s

# XTerm keys
setw -g xterm-keys on

# Esc delay
set -sg escape-time 10

# Windows split keys
bind v split-window -v -c "#{pane_current_path}"
bind h split-window -h -c "#{pane_current_path}"

# resize panes like vim
bind , resize-pane -L 5
bind . resize-pane -R 5
bind - resize-pane -D 5
bind = resize-pane -U 5

bind w new-window
bind x kill-pane
bind l choose-window
bind p resize-pane -Z

# start selection with 'space' and copy using 'y'
bind e copy-mode

bind-key -Tcopy-mode-vi 'v' send -X begin-selection
bind-key -Tcopy-mode-vi 'y' send -X copy-pipe-and-cancel "pbcopy"
