#!/bin/bash

# Commit differences on serer from Craft installs
git add -A
git diff-index --quiet HEAD || git commit -m 'Changes from CMS server' --author="Forge <login@bukwild.com>"
git pull
git push

# Install Composer changes from local dev
cd craft-cms
composer install --no-interaction --prefer-dist --optimize-autoloader
./craft migrate/all --interactive=0
./craft project-config/apply --interactive=0

# Rebuild CMS Stylesheet
yarn install --frozen-lockfile
yarn build

# Prevent cache from getting too large
yarn cache clean
