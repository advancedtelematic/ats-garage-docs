#!/bin/bash

ask() {
    # http://djm.me/ask
    local prompt default REPLY

    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question (not using "read -p" as it uses stderr not stdout)
        echo -n "$1 [$prompt] "

        # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
        read REPLY </dev/tty

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

env_file=s3_credentials.env

set -euo pipefail
IFS=$'\n\t'

# tidy up last run
rm -rf _site

# build latest docs and serve them locally, to check that nothing is horribly broken
docker run --rm -v "$(pwd)":/site -u "$(id -u)":"$(id -g)" -p 4000:4000 advancedtelematic/jekyll-asciidoc jekyll s --config _config.yml,_secrets.yml -H 0.0.0.0

if ! ask "Push this site to S3?" Y; then
    exit 1
fi

# Update the Algolia index?
if ask "Rebuild search index?" Y; then
    docker run --rm -v "$(pwd)":/site -u "$(id -u)":"$(id -g)" -p 4000:4000 advancedtelematic/jekyll-asciidoc jekyll algolia push --config _config.yml,_secrets.yml
fi

# push to s3 using CLI
docker run --rm -it -v "$(pwd)":/project -u "$(id -u)":"$(id -g)" --env-file=$env_file mesosphere/aws-cli s3 sync --delete --exclude *.mp4 _site/ s3://docs.atsgarage.com
rm -rf _site
