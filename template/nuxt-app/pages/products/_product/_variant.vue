<!-- A PDP page -->

<template lang='pug'>

.product.max-w
	h1 Product: {{ product.title }}
	h2 Variants:
	ul: li(v-for='variant in product.variants' :key='variant.id')
		smart-link(:to='variant.url') {{ variant.title }}
		span(v-if='variant.id == currentVariant.id')  (Active)

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
import pageMixin from '@bkwld/cloak/mixins/page'
import getCraftPages from '~/queries/craft-pages.gql'
import getShopifyProduct from '~/queries/shopify-product.gql'
export default
	name: 'PDP'

	mixins: [ pageMixin ]

	# Structured meta
	head: -> {
		...@buildHead
			title: @product.title
			description: @product.description
			image: @primaryImage
		# script: [ makeJsonLdProductTag
		# 	name: @product.title
		# 	image: @primaryImage
		# 	description: @product.description
		# 	sku: @currentVariant?.sku
		# 	url: @currentVariant?.url || process.env.URL + @$route.path
		# 	price: @currentVariant?.price.amount
		# 	available: @currentVariant?.available
		# ]
	}

	# Get Product data
	asyncData: ({ app, store, params, payload }) ->

		# Get product data
		[ product ] = payload || await app.$craft.getEntries
			query: getCraftPages
			variables:
				section: 'products'
				uri: "products/#{params.product}"
		return app.$notFound() unless product

		# Get Shopify data
		{ product: shopifyProduct } = await app.$storefront.execute
			query: getShopifyProduct
			variables: handle: params.product

		# Check that the product and variant exist
		return app.$notFound() unless shopifyProduct
		if params.variant and !shopifyProduct.variants.find (variant) ->
			params.variant == app.$getShopifyId variant.id
		then return app.$notFound()

		# Merge shopify data with product
		product = {
			...product
			...shopifyProduct
		}

		# Add URLs to each variant for easier iteration later
		product.variants = product.variants.map (variant) =>
			variantIdNum = app.$getShopifyId variant.id
			{
				...variant
				url: "#{process.env.URL}/products/#{product.slug}/#{variantIdNum}"
			}

		# Set the initial variant
		currentVariant = switch

			# No variant in URL, so default to first variant
			when !params.variant then product.variants[0]

			# Set to variant that was in the URL
			else product.variants.find (variant) =>
				params.variant == app.$getShopifyId variant.id

		# Set data
		return { product, currentVariant }

	watch:

		# Fire GTM event on variant change
		currentVariant:
			immediate: true
			handler: -> @$gtmEcomm.viewProductDetails @currentVariant.id

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

.product
	padding-top header-h
	background primary-color

</style>
