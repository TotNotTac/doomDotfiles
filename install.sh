#!/bin/bash

error=0

if command -v git >/dev/null 2>&1
then
    git --version
else
    echo "git not installed"
    error=1
fi

if command -v emacs >/dev/null 2>&1
then
    emacsversion=$(emacs --version | head -n 1 | awk '{ print $3 }')
    echo "emacs version $emacsversion"
else
    echo "emacs is not installed"
    error=1
fi

if [ $error -eq 1 ]
then
    echo "Dependency requirements were not met."
    echo "Aborting..."
    echo ""
    exit 1
fi

git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install

emacs & disown
