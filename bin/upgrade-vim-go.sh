#!/bin/bash

echo "Upgrading go tools ..."
go get -v -u golang.org/x/tools/...

echo "Upgrading vim-go binaries ..."
vim +GoUpdateBinaries +qall

echo "Upgrading gometalinter tools ..."
gometalinter --install --update

