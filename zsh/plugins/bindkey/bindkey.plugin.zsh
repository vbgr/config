# https://unix.stackexchange.com/questions/547/make-my-zsh-prompt-show-mode-in-vi-mode/1019

# bindkey -v

# function zle-line-init zle-keymap-select {
#     RPROMPT=${${KEYMAP/vicmd/'[vi]'}/(main|viins)/''}
#     zle reset-prompt
# }

# zle -N zle-line-init
# zle -N zle-keymap-select

# bindkey "^G" vi-cmd-mode
bindkey -e
