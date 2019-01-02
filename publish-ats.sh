#!/bin/bash

[ -z "$1" ] && echo "Usage: $0 <staging|prod|here>" && exit 1

env_file=s3_credentials.env

# tidy up last run
rm -rf _site-ats

# Update the Algolia index?
# if ask "Rebuild search index?" Y; then
#     docker run --rm -v "$(pwd)":/site -u "$(id -u)":"$(id -g)" -p 4000:4000 advancedtelematic/jekyll-asciidoc jekyll algolia push --config _config.yml,_secrets.yml
# fi

# push to s3 using CLI
if [ "$1" == "prod" ]; then
  docker run --rm -v "$(pwd)":/site -u "$(id -u)":"$(id -g)" advancedtelematic/jekyll-asciidoc jekyll b --config _conf-here.yml,_secrets.yml --destination ./_site-ats
  docker run --rm -v "$(pwd)":/project -u "$(id -u)":"$(id -g)" --env-file=$env_file mesosphere/aws-cli s3 sync --delete --exclude *.mp4 _site-ats/ s3://docs.atsgarage.com
  echo "Docsite pushed to https://docs.atsgarage.com/"
elif [ "$1" == "staging" ]; then
  docker run --rm -v "$(pwd)":/site -u "$(id -u)":"$(id -g)" advancedtelematic/jekyll-asciidoc jekyll b --config _conf-here.yml,_secrets.yml --destination ./_site-ats
  docker run --rm -v "$(pwd)":/project -u "$(id -u)":"$(id -g)" --env-file=$env_file mesosphere/aws-cli s3 sync --delete --exclude *.mp4 _site-ats/ s3://docs-staging.atsgarage.com
  echo "Docsite pushed to http://docs-staging.atsgarage.com.s3-website.eu-central-1.amazonaws.com/"
elif [ "$1" == "here" ]; then
  docker run --rm -v "$(pwd)":/site -u "$(id -u)":"$(id -g)" advancedtelematic/jekyll-asciidoc jekyll b --config _conf-ats.yml,_secrets.yml --destination ./_site-ats
  docker run --rm -v "$(pwd)":/project -u "$(id -u)":"$(id -g)" --env-file=$env_file mesosphere/aws-cli s3 sync --delete --exclude *.mp4 _site-ats/ s3://docs.ota.here.com
  echo "Docsite pushed to https://docs.ota.here.com/"
else
  echo "Usage: $0 <staging|prod|here>" && exit 1
fi
rm -rf _site-ats
