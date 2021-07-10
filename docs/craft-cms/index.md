# Craft CMS - Configuration

## Assets

The project config ships with two Asset Volumes (see /admin/settings/assets):

- Assets - A DigitalOcean Space Volume
- Local - Stores assets in craft-cms/web/uploads

If you are using craft-cms locally, I recommend going to the Assets tab and uploading directly to "Local" (/admin/assets/local) since all of the Asset _fields_ default to the "Assets" volume.  Then you can use the "Add an Asset" button to find those assets from your local Entries.

When you setup Craft CMS on a production server, you would delete the "Local" volume and only use "Assets".

## Branding

Go to `/admin/settings/general` and customize update the `System Name` and logos to be specific to your project.

## Email

A Bukwild mailgun provider is baked into the project config.  Just provide the `EMAIL_PASSWORD` value to the .env (this can be found [in Passwork](https://passwork.me/#!/p/60a68d7715aaca7283342a7e)).

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
