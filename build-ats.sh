#!/bin/bash

rm -rf _site-ats
docker run --rm -v "$(pwd)":/site -u "$(id -u)":"$(id -g)" -p 4000:4000 advancedtelematic/jekyll-asciidoc jekyll b --config _conf-ats.yml,_secrets.yml --destination ./_site-ats


