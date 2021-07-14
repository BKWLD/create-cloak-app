# Craft CMS - Configuration

## Assets

The project config ships with two Asset Volumes (see /admin/settings/assets):

- Assets - A DigitalOcean Space Volume
- Local - Stores assets in craft-cms/web/uploads

When you setup Craft CMS on a production server, you should delete the "Local" volume and only use "Assets".

## Branding

Go to `/admin/settings/general` and customize update the `System Name` and logos to be specific to your project.

## Colors

Change the Background Color field from being of type "color" to being "colorit" so you can enforce brand colors.  You'll also want to define presets for this field in the Colorit plugin settings.  The project doesn't ship with Background Color as "colorit" because that plugin doesn't currently support Project Config.

## Email

A Bukwild mailgun provider is baked into the project config.  Just provide the `EMAIL_PASSWORD` value to the .env (this can be found [in Passwork](https://passwork.me/#!/p/60a68d7715aaca7283342a7e)).

## Project Config

A rule in the .gitignore disables future changes to config/project (from Craft's [Project Config](https://craftcms.com/docs/3.x/project-config.html) feature) from being committed and deployed.  This was done with an assumption the Craft will be installed to a public server early on and all configuration changes will be done on the server.  If config changes were also committed locally, we would likely run into git conflicts when deploying the CMS.

If you want manage the schema on dev environments only, just remove the `config/project` line from the gitignore.

## Redactor

There are two Redactor configs:

- Simple - Used in places that only support inline elements like bold, link, etc.
- Default - Full WYSIWYG with opinionated, ADA-friendly formatting rules.  They are "opinionated" in that not all heading styles are available on all heading tags.  For instance, there isn't an option to apply an h1 style to a h5 tag.  This is done to reduce the overall formatting options.

If you uncomment the import of `definitions.styl` in [./styles/index.styl](./styles/index.styl) and your project defines functions for `style-h1`, `style-h2`, etc, then Redactor will use those styles for it's formatting menu.

## Sentry

Populate the `SENTRY_DSN` env variable to send CMS-level errors to Sentry.

## Spaces

Assets are expected to be stored using Digital Ocean Spaces.  Create a Space in the DO panel if you haven't yet and enter the credentials in the .env file in the `SPACES_*` variables.

## Webhooks

Create two webhooks [as described here](./webhooks.md) to trigger deploys on content change or delete.
