#!/bin/bash

[ -z "$1" ] && echo "Usage: $0 <gerrit_username>" && exit 1

set -euo pipefail

# clean up last run
rm -rf _tmp-git/ || true

# get the current SHA
COMMIT_ID=$(git rev-parse --short HEAD)

# check out latest docsite from gerrit
git clone ssh://${1}@gerrit.it.here.com:29418/DOCS/ota_update_platform.git _tmp-git
# wipe out the html artefacts directory
rm -rf _tmp-git/passthrough/dev_guide/ats_custom_asciidoc/1.0.0/auto/en-US/html/*
# build the site into the html artefacts directory
docker run --rm -v "$(pwd)":/site -u "$(id -u)":"$(id -g)" -p 4000:4000 advancedtelematic/jekyll-asciidoc jekyll b \
    --config _conf-here.yml,_secrets.yml --destination ./_tmp-git/passthrough/dev_guide/ats_custom_asciidoc/1.0.0/auto/en-US/html
# add the files, make a commit
cd _tmp-git
git add passthrough/dev_guide/ats_custom_asciidoc/1.0.0/auto/en-US/html/
git commit -m "Content generated from ats-garage-docs@${COMMIT_ID}"
#git push origin master

# clean up
cd ..
#rm -rf _tmp-git