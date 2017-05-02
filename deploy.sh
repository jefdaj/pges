#!/usr/bin/env bash

# Copies src/_site/* to the CalWeb server.
# Consider testing your changes on ocf.berkeley.edu first!
# Ask Jeff for the ssh key + settings.

SITEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/src/_site"
rsync -aEvrz --delete "$SITEDIR"/* pges:~/apache2/https-pges/htdocs/
