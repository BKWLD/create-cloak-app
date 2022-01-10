# Shopify

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

4. Create repository in GitLab and push code up.

5. Create `deploy/dev` branch in GitLab.

6. Do the [Craft deploy steps](./craft-cms/deploy).

5. Go into the GitLab repo's Settings > CI/CD > Variables and create unprotected and masked variables for:
  - `SHOPIFY_API_PASSWORD_DEV`
  - `SHOPIFY_API_PASSWORD_PROD`
  - `SHOPIFY_STOREFRONT_TOKEN_DEV`
  - `SHOPIFY_STOREFRONT_TOKEN_PROD`

6. Publish the Dev and Prod themes on the respective Shopify store

7. Populate GTM ID in the Theme Settings


