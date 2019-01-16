#!/bin/bash

docker run --rm -v "$(pwd)":/site -u "$(id -u)":"$(id -g)" -p 4000:4000 advancedtelematic/jekyll-asciidoc jekyll b --config _config.yml,_secrets.yml $@
