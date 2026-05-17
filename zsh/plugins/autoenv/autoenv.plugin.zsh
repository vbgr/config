_autoenv() {
  for env_file in ${AUTOENV_FILES}; do
    [[ -f $env_file ]] && source $env_file
  done
}

autoload -U add-zsh-hook
add-zsh-hook chpwd _autoenv
