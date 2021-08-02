#!/bin/bash

# Commit differences on serer from Craft installs
git add -A
git diff-index --quiet HEAD || git commit -m 'Changes from CMS server'
git pull
git push

# Install Composer changes from local dev
cd craft-cms
composer install --no-interaction --prefer-dist --optimize-autoloader

# Rebuild CMS Stylesheet
yarn
yarn build

# Prevent cache from getting too large
yarn cache clean
