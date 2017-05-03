#!/bin/bash

env_file=s3_credentials.env

set -euo pipefail
IFS=$'\n\t'

# tidy up last run
rm -rf _site

# build latest docs
docker run --rm -v $(pwd):/site -u $(id -u):$(id -g) advancedtelematic/jekyll-asciidoc

# commit and push
docker run --rm -it -v $(pwd):/site -u $(id -u):$(id -g) --env-file=$env_file advancedtelematic/jekyll-asciidoc s3_website push
rm -rf _site
