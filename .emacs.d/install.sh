 #!/bin/bash

deps=(
    merlin
    tuareg
    ocp-indent
    utop
    dune
    core
    menhir
    stringext
    ppx_deriving
)

setup_cask () {
  if [ ! -d $HOME/.cask ]; then
    curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
  fi

  cask install
}

setup_eterm_color () {
  curl https://opensource.apple.com/source/emacs/emacs-70/emacs/etc/e/eterm-color.ti\?txt > eterm-color.ti 2>/dev/null
  tic -o ~/.terminfo eterm-color.ti 2>/dev/null
  rm -f eterm-color.ti
}


setup_ocaml () {
  if [ ! -d $home/.opam ]; then
    case "${ostype}" in
        darwin* )
            brew install opam
            ;;
        linux-* )
            sudo apt-get install opam
            ;;
    esac
  fi

  opam install -y ${deps[@]}
}

setup_lsp_java () {
    if test ! -d "./jdt-server/"; then
        mkdir jdt-server
        pushd jdt-server || exit
        wget https://download.eclipse.org/jdtls/milestones/0.31.0/jdt-language-server-0.31.0-201901170528.tar.gz
        tar xfv jdt-language-server-0.31.0-201901170528.tar.gz
        popd
    fi
}

while getopts acoej OPT; do
    case $OPT in
	a)
	    setup_cask
	    setup_eterm_color
	    setup_ocaml
	    ;;
	c)
	    setup_cask
	    ;;
	o)
	    setup_ocaml
	    ;;
	e)
	    setup_eterm_color
	    ;;
        j)
            setup_lsp_java
            ;;
	*)
	    setup_cask
	    ;;
    esac
done

shift $((OPTIND - 1))
