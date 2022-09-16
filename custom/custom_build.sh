#!/bin/bash -e

GOLLUM_VERSION=$1
shift
SRC_REV=$1

[ "$(ls -A /build/custom/patches)" ] && patches=true || patches=false

git clone https://github.com/gollum/gollum
cd gollum
git checkout $SRC_REV
git config user.email "you@example.com"
git config user.name "Your Name"
[ "$patches" = true ] && git am < /build/custom/patches/*
bundle install
rake build
