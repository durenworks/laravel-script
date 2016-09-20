#!/bin/bash

TMP_DIR=`mktemp -d`
trap "rm -rf $TMP_DIR" 0 2 3 15

CUR_DIR=$(pwd)

pushd "$TMP_DIR" > /dev/null
git clone "https://github.com/durenworks/laravel-script.git" .
HASH=$(git rev-parse HEAD)

cp -Rf src/* "$CUR_DIR"
echo "$HASH" > "$CUR_DIR/script.ver"
