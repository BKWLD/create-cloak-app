# Shopify

## Pre-`yarn create cloak-app`

1. Make sure [Shopify Theme Kit](https://shopify.dev/themes/tools/theme-kit/getting-started#macos) is install localled.

2. Make a Private Shopify apps for the Dev and Prod Shopify stores, enabling Storefront API access.  We typically call this app "Bukwild Connect".  You'll need the tokens provided on creation.  Minimum permissions needed:
- Admin API:
  - Themes: Read & Write
- Storefront API:
  - Read products, variants, and collections
  - Read and modify customer details (if supporting headless auth)
  - Read and mofify checkouts
  - Read selling plans (if supporting headless subscriptions like Recharge)

3. If using Imgix, create the account and set the source to the expected DigitalOcean space URL.  The base URL will be like `https://{space-name}.sfo3.digitaloceanspaces.com/cms`.

## Post-`yarn create cloak-app`

1. [Fix](https://github.com/BKWLD/create-cloak-app/issues/36) and populate the `shopify-theme/config.yml`

2. Create a repository in GitLab and push code up.

3. Create `deploy/dev` branch in GitLab.

4. Go into the GitLab repo's Settings > CI/CD > Variables and create unprotected and masked variables for:
  - `SHOPIFY_API_PASSWORD_DEV`
  - `SHOPIFY_API_PASSWORD_PROD`
  - `SHOPIFY_STOREFRONT_TOKEN_DEV`
  - `SHOPIFY_STOREFRONT_TOKEN_PROD`

5. Do the [Craft deploy steps](./craft-cms/deploy).

6. Publish the Dev and Prod themes on the respective Shopify store

7. Populate GTM ID in the Theme Settings
