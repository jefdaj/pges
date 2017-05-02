#!/usr/bin/env bash

# Tries to build the site. If successful it will also serve it at localhost:8000,
# and update when files are changed. If unsuccessful it falls back to GHCi.
# TODO also install stack if needed

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/src"
sudo apt-get install libgmp-dev zlib1g-dev
stack setup && stack build \
  && (stack exec pges2017 watch; stack exec pges2017 clean) \
  || stack repl
