# opening and closing windows and popovers
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

# smooth scrolling
defaults write -g NSScrollAnimationEnabled -bool false

# Fonts
# TODO: set 1 for M1
defaults write -g AppleFontSmoothing -int 0

# showing and hiding sheets, resizing preference windows, zooming windows
# float 0 doesn't work
defaults write -g NSWindowResizeTime -float 0.001

# opening and closing Quick Look windows
defaults write -g QLPanelAnimationDuration -float 0

# press and hold for cursor
defaults write -app Cursor ApplePressAndHoldEnabled -bool false

# rubberband scrolling (doesn't affect web views)
defaults write -g NSScrollViewRubberbanding -bool false

# resizing windows before and after showing the version browser
# also disabled by NSWindowResizeTime -float 0.001
defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false

# showing a toolbar or menu bar in full screen
defaults write -g NSToolbarFullScreenAnimationDuration -float 0

# scrolling column views
defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0

# showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 1
defaults write com.apple.dock autohide-delay -float 0

# showing and hiding Mission Control, command+numbers
defaults write com.apple.dock expose-animation-duration -float 0

# showing and hiding Launchpad
defaults write com.apple.dock springboard-show-duration -float 0
defaults write com.apple.dock springboard-hide-duration -float 0

# changing pages in Launchpad
defaults write com.apple.dock springboard-page-duration -float 0.3

# at least AnimateInfoPanes
defaults write com.apple.finder DisableAllAnimations -bool true

# sending messages and opening windows for replies
defaults write com.apple.Mail DisableSendAnimations -bool true
defaults write com.apple.Mail DisableReplyAnimations -bool true

# key repeat in vscode
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# key repeat
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.cm commit
git config --global alias.st status
