zplug "zplug/zplug", \
      hook-build:'zplug --self-manage'

zplug "zsh-users/zsh-completions"

zplug "zsh-users/zsh-syntax-highlighting", \
      defer:2

zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"
zplug "changyuheng/zsh-interactive-cd"
zplug "mollifier/cd-gitroot"

zplug "rhysd/zsh-bundle-exec", \
      use:zsh-bundle-exec.zsh

zplug "Tarrasch/zsh-bd", \
      use:bd.zsh

zplug "rupa/z", \
      use:z.sh

zplug "b4b4r07/enhancd", \
      use:init.sh

zplug "motemen/ghq", \
      as:command, \
      from:gh-r, \
      rename-to:ghq

zplug "junegunn/fzf-bin", \
      as:command,\
      from:gh-r, \
      rename-to:fzf

zplug "peco/peco", \
      as:command, \
      from:gh-r

zplug "~/.zsh/util", \
      from:local

zplug "bhilburn/powerlevel9k",\
      use:powerlevel9k.zsh-theme

#zplug "3tty0n/powerline-shell", at:develop, hook-build:"make install"

zplug load
