#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# tidy up last run
rm -rf _site

# clone repo into _site directory
git clone -b gh-pages git@github.com:advancedtelematic/ats-garage-docs.git _site

# build latest docs
# For a docker-contained build, do this:
# docker run -v $(pwd):/site advancedtelematic/jekyll-asciidoc
jekyll b

# commit and push

cd _site
git add -A :/
git commit -m "built site for commit $(git -C ../ log --pretty=format:'%h' -n 1)"
git show --numstat
git push origin gh-pages
cd ..
rm -rf _site
