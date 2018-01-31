#!/usr/bin/env bash

# Tries to build the site. If successful it will also serve it at localhost:8000,
# and update when files are changed. If unsuccessful it falls back to GHCi.
# TODO also install stack if needed

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/src"
which apt-get &> /dev/null && sudo apt-get install libgmp-dev zlib1g-dev
which dnf     &> /dev/null && sudo dnf install gmp-devel zlib-devel
mkdir -p .stack-work/tmp
export TMPDIR="$PWD"/.stack-work/tmp
stack setup && stack build \
  && (stack exec pges watch; stack exec pges clean) \
  || stack repl
