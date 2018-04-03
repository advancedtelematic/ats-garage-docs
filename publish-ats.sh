#!/bin/bash

env_file=s3_credentials.env

# tidy up last run
rm -rf _site-ats

# Update the Algolia index?
# if ask "Rebuild search index?" Y; then
#     docker run --rm -v "$(pwd)":/site -u "$(id -u)":"$(id -g)" -p 4000:4000 advancedtelematic/jekyll-asciidoc jekyll algolia push --config _config.yml,_secrets.yml
# fi

# build the site
docker run --rm -v "$(pwd)":/site -u "$(id -u)":"$(id -g)" -p 4000:4000 advancedtelematic/jekyll-asciidoc jekyll b --config _conf-ats.yml,_secrets.yml --destination ./_site-ats
# push to s3 using CLI
docker run --rm -it -v "$(pwd)":/project -u "$(id -u)":"$(id -g)" --env-file=$env_file mesosphere/aws-cli s3 sync --delete --exclude *.mp4 _site-ats/ s3://docs.atsgarage.com
rm -rf _site-ats
