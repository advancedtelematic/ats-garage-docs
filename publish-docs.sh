#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# tidy up last run
rm -rf _site

# clone repo into _site directory
git clone -b gh-pages --depth 1 git@github.com:advancedtelematic/ats-garage-docs.git _site

# build latest docs
docker run -v $(pwd):/site advancedtelematic/jekyll-asciidoc

# commit and push

cd _site
git add -A :/
git commit -m "built site for commit $(git -C ../ log --pretty=format:'%h' -n 1)"
git show --numstat
git push origin gh-pages
cd ..
rm -rf _site
