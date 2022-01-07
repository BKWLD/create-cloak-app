import * as craft from '@bkwld/cloak/services/craft.coffee'
import * as storefront from 'library/services/shopify/storefront.coffee'
import { getShopifyId } from 'library/helpers/formatting'

# Add URLs to variant pages to the SSGed list
export default ->

	# Hook to extend routes
	@nuxt.hook 'generate:extendRoutes', (routes) =>

		# Get all the variant routes
		variantRoutes = await buildVariantRoutes routes

		# Register a hook that to add variants to the sitemap
		@nuxt.hook 'sitemap:generate:before', (nuxt, sitemapOptions) =>
			sitemapRoutes = await @nuxt.options.sitemap.routes()
			@nuxt.options.sitemap.routes = [ ...sitemapRoutes, ...variantRoutes ]

		# Append the variant routes to the routes, has to be done in place
		routes.push route for route in variantRoutes

# Add variants to the routes
buildVariantRoutes = (routes) ->
	variantRoutes = []

	# Get all products
	products = await craft.getEntries query: """
			query($site:[String]) {
				entries(
					site:    $site
					section: "products"
				) {
					slug
					uri
				}
			}
		"""

	# Build list of variant routes
	for product in products

		# Get the product payload from the routes
		productPayload = routes
			.find (route) -> route.route == "/#{product.uri}"
			.payload

		# Get all of the variant ids of this product from Shopify
		{ product: shopifyProduct } = await storefront.execute query: """
			query {
				product: productByHandle(handle:"#{product.slug}") {
					variants(first:100) {
						edges {
							node { id }
						}
					}
				}
			}
		"""

		# If no Shopify product, remove route for the product
		unless shopifyProduct
			index = routes.findIndex (route) -> route.route == "/#{product.uri}"
			if index >= 0 then routes.splice index, 1
			console.warn "Shopify product not found for #{product.slug}"
			continue

		# Push new route objects onto the stack
		for variant in shopifyProduct.variants
		then variantRoutes.push
			route: "/#{product.uri}/#{getShopifyId(variant.id)}"
			payload: productPayload

	# Return the updated list of routes
	return variantRoutes
