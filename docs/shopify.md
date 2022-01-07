# Shopify - Setup

1. Make sure [Shopify Theme Kit is installed](https://shopify.dev/themes/tools/theme-kit/getting-started#macos).

2. Make a Private Shopify apps for the Dev and Prod Shopify stores, enabling Storefront API access.  We typically call this app "Bukwild Connect".  You'll need the tokens provided on creation.  Minimum permissions needed:
- Admin API:
  - Themes: Read & Write
- Storefront API:
  - Read products, variants, and collections
  - Read and modify customer details (if supporting headless auth)
  - Read and mofify checkouts
  - Read selling plans (if supporting headless subscriptions like Recharge)

3. Go into the GitLab repo's Settings > CI/CD > Variables and create variables for:
  - `IMGIX_URL` (optional but recommended)
  - `SHOPIFY_API_PASSWORD_DEV`
  - `SHOPIFY_API_PASSWORD_PROD`
  - `SHOPIFY_STOREFRONT_TOKEN_DEV`
  - `SHOPIFY_STOREFRONT_TOKEN_PROD`
