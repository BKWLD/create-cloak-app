# create-cloak-app

Sets up a new [Cloak](https://github.com/BKWLD/cloak) (Nuxt + Craft/Contentful) based project.  The goal of this project is to provide a place to store best practices and conventions across projects.  Secondarily, the developer should have a functioning Hello World app after running the install command.

![](https://i.pinimg.com/originals/75/af/04/75af04c5f9fa6e26231640f7d368f042.gif)

## Usage

From the directory you want to create the new Cloak app:

```
yarn create cloak-app
```

This will ask you a handful of questions, copy relevant files from the [template](./template), init a new git repo, and run initial install commands.  You will then have a local Nuxt-based app that will be immediately bootable.

After you've created a new cloak-app, there are subsequent steps you'll likely need to take based on your choices.  You'll be prompted to visit the following docs pages following a successful completion.

- [Setup Netlify app](./docs/netlify.md)
- [Configure Craft](./docs/craft-cms/config.md)
