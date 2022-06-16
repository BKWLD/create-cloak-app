<!-- Demo of using products helper to merge Craft and Shopify product data -->

<template lang='pug'>

.cards-example.max-w
	h2 Example of rendering product cards
	.product(v-for='product in products' :key='product.id')
		h3 {{ product.title }}
		ul: li(v-for='variant in product.variants' :key='variant.id')
			smart-link(:to='variant.url')
				| {{ variant.title }} - ${{ variant.price.amount }}

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
import craftProductCard from '~/queries/fragments/product-card.gql'
import { mergeShopifyProductCards } from 'library/helpers/products'
export default

	data: -> products: []

	# Fetch 3 products from Craft and get their Shopify data
	fetch: ->

		# Get Craft products
		products = await @$craft.getEntries query: '''
			query {
				entries(section:"products", limit: 3) {
					...productCard
				}
			}
			''' + craftProductCard

		# Merge Shopify data
		@products = await mergeShopifyProductCards products

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

.products-demo
	fluid-space margin-v, 'l'

</style>
