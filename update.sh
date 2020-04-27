#!/bin/bash

dir=$(pwd)

git pull

cd ~/.emacs.d
git pull
./bin/doom upgrade

cd $dir
