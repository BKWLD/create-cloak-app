<!-- A PDP page -->

<template lang='pug'>

.product: .marquee: .max-w

	//- Example product data
	h1 {{ product.title }}
	h2 Variants
	ul: li(v-for='variant in product.variants' :key='variant.id')
		smart-link(:to='variant.url') {{ variant.title }}
		span(v-if='variant.id == currentVariant.id')  (Active)

	//- Example cart state
	.cart
		h2 Cart ({{ $store.getters['cart/itemCount'] }})

		//- Cart listing
		ul: li(v-for='line in $store.state.cart.lines' :key='line.id')
			| {{ line.variant.product.title }} -
			|  {{ line.variant.title }}
			|  x{{ line.quantity }}
			|  = {{ $formatMoney(line.estimatedCost.totalAmount.amount) }}
			| &nbsp;
			a(@click='deleteLine(line)') Delete

		//- Cart actions
		.actions
			btn(:adding='adding' @click='addToCart') Add to Cart
			btn(
				v-if='!$store.state.cart.hydrated'
				@click='$store.dispatch("cart/fetchUnlessHydrated")') Load Cart
			btn(
				v-if='$store.state.cart.lines.length'
				:to='$store.state.cart.checkoutUrl') Checkout

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

	data: ->
		adding: false # Add to cart loading state

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

	methods:

		# Add product to cart
		addToCart: ->
			@adding = true
			await @$store.dispatch 'cart/addItem',
				id: @currentVariant.id
			@adding = false

		# Delete product from cart
		deleteLine: ({ id }) ->
			@$store.dispatch "cart/updateLine", { id, quantity: 0 }

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

// Coordinate layout with header
.marquee
	padding-bottom spacing-m
	background offwhite
	+tablet-up()
		padding-top header-h + spacing-m
	+tablet-down()
		padding-top mobile-header-h + spacing-m

// Quick sections
h2
	margin-top spacing-m
	margin-bottom spacing-xs
	border-bottom 1px solid darken(offwhite, 20%)

// Style lists
li
	list-style-type: circle
	&:not(:first-child)
		margin-top 5px

// Seperate action buttons
.actions
	margin-top spacing-xs
.btn:not(:first-child)
	margin-left 5px

// Style link
a
	text-decoration underline

</style>
