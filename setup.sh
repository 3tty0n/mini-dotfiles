#!/bin/zsh

DOTFILES_ROOT=$(cd $(dirname $0) && pwd)

declare -a dotfiles=()
declare -a dotfiles=(
    .vimrc
    .vimrc.local.vim
    .tmux.conf
    .gitconfig
    .gitignore_global
    .irbrc
    .latexmkrc
    .gemrc
    .zshenv
    .zshrc
    .zprofile
    .zsh
    .tigrc
    .sbtrc
    .spacemacs
    .emacs.d
)

declare -a vimfiles=()
declare -a vimfiles=(ftplugin snippets)

declare -a configfiles=()
declare -a configfiles=(fish omf)

declare -a ghqrepos=()
declare -a ghqrepos=(bahlo/iterm-colors t3chnoboy/thayer-bright-iTerm)


usage () {
  echo "Usage:" `basename $0` "[OPTIONS]"
  echo " This script is the set up tool for 3tty0n's environment."
  echo
  echo "Options:"
  echo "  -h          show help"
  echo "  -b          install brew formulas"
  echo "  -s          make symbolik links"
  echo "  -z          setup zsh plugins managed by zplug"
  echo "  -g          get github repo that is needed in my environment"
  echo "  -a          execute all instructions"
  exit 0
}

mk_symlink() {
  printf "makeing symbolik links...\n"
  { for f in ${dotfiles[@]}; do
    if [ "$f" = ".vimrc" ]; then
      ln -sfnv "$DOTFILES_ROOT/.vimrc.bootstrap" "$HOME/.vimrc"
    else
      ln -sfnv "$DOTFILES_ROOT/$f" "$HOME/$f"
    fi
  done

  [ ! -e ~/.vim ] && mkdir ~/.vim
  for vimfile in "${vimfiles[@]}"; do
    ln -sfnv "$DOTFILES_ROOT/.vim/$vimfile" "$HOME/.vim/$vimfile"
  done

  #for config in ${configfiles[@]}; do; ln -sfnv $DOTFILES_ROOT/.config/$config ~/.config; done

  if [ ! -e ~/.config/gist ]; then
    mkdir -p ~/.config/gist
    cp -v "$DOTFILES_ROOT/.config/gist/config.toml" ~/.config/gist
  fi }>/dev/null


}

setup_zplug () {
  if [ ! -e ~/.zplug ]; then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
  fi
}

setup_githubrepo () {
  printf "cloling github repos...\n"
  if [ ! -x "$(which go)" ]; then
    echo "\`go' is not installed."
    echo "Please install go via \'brew install go'"
    exit 1
  fi
  { for repo in "${ghqrepos[@]}"; do
    if [ ! -d "$(ghq root)/github.com/$repo" ]; then
      ghq get "https://github.com/$repo"
    fi
  done
  for repo in rbenv pyenv; do
    if [ ! -d $HOME/.$repo ]; then
      git clone git@github.com:$repo/$repo.git $HOME/.$repo
    fi
  done }>/dev/null
}

function setup_opam {
    echo "setup OCaml environment..."
    echo ""
    opam init
    opam switch 4.06.1
    opam install -y core ounit
    eval `opam config env`
}

brew_bundle () {
  if [ ! -x "$(which brew)" ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  cd brew || exit
  printf "tapping brew bundle...\n"
  (brew tap Homebrew/bundle)>/dev/null
  printf "installing brew packages...\n"
  (brew bundle)>/dev/null
}

for OPT in "$@"
do
  case $OPT in
    '-h' )
      usage
      ;;
    '-s' )
      mk_symlink
      ;;
    '-b' )
      brew_bundle
      ;;
    '-z' )
      setup_zplug
      ;;
    '-g' )
      setup_githubrepo
      ;;
    '-a' )
      mk_symlink
      brew_bundle
      setup_zplug
      setup_githubrepo
      setup_opam
      ;;
    -*)
        echo "$PROGNAME: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
        exit 1
        ;;
    *)
        if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
            #param=( ${param[@]} "$1" )
            param+=( "$1" )
            shift 1
        fi
  esac
  shift
done

#if [ -z $param ]; then
#    echo "$PROGNAME: too few arguments" 1>&2
#    echo "Try '$PROGNAME -h' for more information." 1>&2
#    exit 1
#fi
