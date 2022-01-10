<!-- The PDP marquee -->

<template lang='pug'>

.pdp-marquee: .max-w

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
export default

	props:
		product: Object
		currentVariant: Object

	data: ->
		adding: false # Add to cart loading state

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
.pdp-marquee
	padding-bottom spacing-m
	background offwhite
	+tablet-up()
		padding-top header-h + spacing-m
	+tablet-down()
		padding-top header-h-mobile + spacing-m

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
