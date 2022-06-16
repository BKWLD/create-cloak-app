# create-cloak-app

Sets up a new [Cloak](https://github.com/BKWLD/cloak) (Nuxt + CMS) based project.  Supported CMSs are Craft, Contentful and @nuxt/content.  The goal of this project is to provide a place to store best practices and conventions across projects.  Secondarily, the developer should have a functioning Hello World app after running the install command.

![](https://i.pinimg.com/originals/75/af/04/75af04c5f9fa6e26231640f7d368f042.gif)

## Usage

From the directory you want to create the new Cloak app:

```
yarn create cloak-app
```

This will ask you a handful of questions, copy relevant files from the [template](./template), init a new git repo, and run initial install commands.  You will then have a local Nuxt-based app that will be immediately bootable.

After you've created a new cloak-app, there are subsequent steps you'll likely need to take based on your choices.  You'll be prompted to visit the following docs pages following a successful completion.

- [Provision Netlify apps](https://bukwild.slab.com/posts/provision-netlify-app-f3fbea34)
- [Deploy & Configure Craft](https://bukwild.slab.com/posts/deploy-configure-craft-rc0v20z4)
- [Setup Custom Storefront Infrastructure](https://bukwild.slab.com/posts/configure-shopify-da1tf5wt)

## Contributing

1. Run `yarn sao ./ ~/Desktop/cloak-app` to create an Cloak instance to iterate on on your desktop.
2. Track the changes you make to that instance using the git repo that was automatically set up.
3. Replay those changes (manually, unless someone has some git brilliance to share), back onto the /template directory as part of a PR.
