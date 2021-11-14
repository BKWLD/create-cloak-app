# Netlify - Setup

## Initial Setup
- Connect the repo (via New site from Git button)
- authorize access to gitlab, github, etc if nessesary

## Build Settings
- *Base directory*`*: if the repository is the app itself, then this can be blank. However, if the app is in a subdirectory, then that would be this value, example: `demo`

- *Build command*: this should be `yarn generate`

- *Publish directory*: normally, this would be `dist`, but if you have the app in a subdirectory, like the example above, it would be `demo/dist`

