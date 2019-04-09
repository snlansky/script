#!/bin/sh

go get -u github.com/dougm/goflymake
go get -u github.com/rogpeppe/godef
go get -u github.com/kisielk/errcheck
go get -u github.com/nsf/gocode

go get -u github.com/mdempsky/gocode # github.com/nsf/gocode
go get -u golang.org/x/lint/golint
go get -u golang.org/x/tools/cmd/guru
go get -u golang.org/x/tools/cmd/gorename
go get -u golang.org/x/tools/cmd/gotype
go get -u golang.org/x/tools/cmd/godoc
go get -u github.com/derekparker/delve/cmd/dlv
go get -u github.com/josharian/impl
go get -u github.com/cweill/gotests/...
go get -u github.com/fatih/gomodifytags
go get -u github.com/davidrjenni/reftools/cmd/fillstruct

gocode set propose-builtins true
