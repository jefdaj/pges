#!/usr/bin/env bash

# Copies src/_site/* to the public_html folder on Jeff's ocf.berkeley.edu
# account, which we use as a test site. You can use it or set up your own,
# or ask him for the ssh key.

SITEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/src/_site"
rsync -aEvrz --delete "$SITEDIR"/* ocf:~/public_html/
