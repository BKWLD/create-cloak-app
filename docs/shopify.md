# Shopify - Setup

1. Make a Private Shopify apps for the Dev and Prod Shopify stores, enabling Storefront API access.  We typically call this app Bukwild Connect.  You'll need the tokens provided on creation.

2. Go into the GitLab repo's Settings > CI/CD > Variables and create variables for:
  - `IMGIX_URL` (optional but recommended)
  - `SHOPIFY_API_PASSWORD_DEV`
  - `SHOPIFY_API_PASSWORD_PROD`
  - `SHOPIFY_STOREFRONT_TOKEN_DEV`
  - `SHOPIFY_STOREFRONT_TOKEN_PROD`
