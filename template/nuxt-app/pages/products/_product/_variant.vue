<!-- A PDP page -->

<template lang='pug'>

.product

	//- Make an example of the marquee
	pdp-marquee(
		:product='product'
		:currentVariant='currentVariant')

	//- Show an example of rendering a list of product cards
	pdp-cards-example

	//- List the blocks
	blocks-list(:blocks='product.blocks')

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
import pageMixin from '@cloak-app/craft/mixins/page'
import getProduct from '~/queries/product.gql'
import getShopifyProduct from '~/queries/shopify-product.gql'
export default
	name: 'PDP'

	mixins: [ pageMixin ]

	# Structured meta
	head: -> @buildHead
		title: @product.title
		description: @product.description
		image: @primaryImage
		canonical: @currentVariant?.url

	# Get Product data
	asyncData: ({ $craft, $storefront, $notFound, $getShopifyId, params }) ->

		# Get product data
		product = await $craft.getEntries
			query: getProduct
			variables: uri: "products/#{params.product}"
		return $notFound() unless product

		# Get Shopify data
		{ product: shopifyProduct } = await $storefront.execute
			query: getShopifyProduct
			variables: handle: params.product

		# Check that the product and variant exist
		return $notFound() unless shopifyProduct
		if params.variant and !shopifyProduct.variants.find (variant) ->
			params.variant == $getShopifyId variant.id
		then return $notFound()

		# Merge shopify data with product
		product = {
			...product
			...shopifyProduct
		}

		# Add URLs to each variant for easier iteration later
		product.variants = product.variants.map (variant) =>
			variantIdNum = $getShopifyId variant.id
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
				params.variant == $getShopifyId variant.id

		# Set data
		return { product, currentVariant }

	computed:

		# This will be used by head-tags via pageMixin
		page: -> @product

		# Make an image ref that can be used for og:image or json-ld
		primaryImage: -> @currentVariant.image?.src

	watch:

		# Fire GTM event on variant change
		currentVariant:
			immediate: true
			handler: -> @$gtmEcomm.viewProductDetails @currentVariant.id

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>


</style>
