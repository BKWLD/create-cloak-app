# <%= name %>

This repo is setup as a [Yarn Workspace](https://classic.yarnpkg.com/en/docs/workspaces/).  It is comprised of:

<%_ if (cms == 'craft') { _%>
- [`craft-cms`](./craft-cms) - CMS powered by [Craft](https://craftcms.com/).
<%_ } _%>
<%_ if (hasLibrary) { _%>
- [`library`](./library) - Shared components and other codes used by the other packages.
<%_ } _%>
- [`nuxt-app`](./nuxt-app) - The statically generated app core of the website.
<%_ if (shopify) { _%>
- [`shopify-theme`](./shopify-theme) - The Shopify theme.
<%_ } _%>
