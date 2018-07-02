#!/bin/bash

if [ -z "$GIT_EMAIL" ]; then
 echo "You need to pass the \$GIT_EMAIL variable to the container for this to work"
 exit
fi

if [ -z "$GIT_NAME" ]; then
 echo "You need to pass the \$GIT_NAME variable to the container for this to work"
 exit
fi

# Try auto install for composer
if [ -f "${SITEROOT}/composer.lock" ]; then
  composer install --no-dev --working-dir=${SITEROOT}
fi

cd ${SITEROOT}
git pull origin ${GIT_BRANCH}|| exit 1
