import * as cartApi from 'library/services/shopify/cart'
import { makeShopifyUrl } from 'library/helpers/routing'
import { cookie } from 'library/helpers/storage'
import { CART_ID_KEY, CART_COUNT_KEY } from 'library/helpers/constants'

# Make the client client side
export getCart = ->

	# Lookup or make the checkout
	cart = if cartId = cookie.get CART_ID_KEY
	then await cartApi.fetch cartId
	cart = await cartApi.create() unless cart

	# Update the cookie exiration
	# https://regex101.com/r/fVhyob/1/
	cookie.set CART_ID_KEY, cart.id, expires: 14 # Days

	# Return the cart
	return cart

# Stores the Shopify cart state
# https://shopify.dev/docs/ajax-api/reference/cart#get-cart-js
export state = ->

	# Default values for Shopify properties we consume
	id: null
	lines: []
	estimatedCost:
		subtotalAmount: amount: 0
		totalAmount: amount: 0
		totalTaxAmount: amount: 0
	discountCodes: []
	checkoutUrl: '' # The checkout URL

	# App-specific cart values
	open: false # The open/close state of the flyout
	hydrated: false # Whether we've fetched the cart yet

export getters =

	# Helper for accessing totals
	subtotal: (state) -> state.estimatedCost.subtotalAmount.amount
	total: (state) -> state.estimatedCost.totalAmount.amount
	tax: (state) -> state.estimatedCost.totalTaxAmount?.amount || 0

	# Get the quantity of items in the cart
	itemCount: (state) ->
		unless state.hydrated then return cookie.get CART_COUNT_KEY || 0
		state.lines.reduce (sum, line) ->
			sum + line.quantity
		, 0

	# Determine if the cart contains a subscription
	hasSubscription: (state) ->
		!!state.lines.find (line) -> !!line.sellingPlanAllocation

	# Determine if the cart contains one time purchaess
	hasNonSubscription: (state) ->
		!!state.lines.find (line) -> !line.sellingPlanAllocation

export mutations =

	# Replace the current cart with the new one
	replace: (state, cart) -> Object.assign state, cart

	# Open/close the cart flyout
	open: (state) -> state.open = true
	close: (state) -> state.open = false

	# Mark has hydrated
	isHydrated: (state) -> state.hydrated = true

export actions =

	# Add an item to the cart
	addItem: (
		{ state, dispatch, commit },
		{ id: variantId, quantity = 1, sellingPlanId }
	) ->
		try
			await dispatch 'fetchUnlessHydrated'
			cart = await cartApi.addVariant
				cartId: state.id
				variantId: variantId
				quantity: parseInt quantity
				sellingPlanId: sellingPlanId
			commit 'replace', cart
		catch e then console.error e

	# Change an item's quantity. If the quantity is 0, delete the line. Auto
	# close the cart if the total items equals 0.
	updateLine: (
		{ state, dispatch, commit, getters },
		{ quantity, id: lineId, sellingPlanId }
	) ->
		try
			await dispatch 'fetchUnlessHydrated'
			if quantity > 0
			then cart = await cartApi.updateLine
				cartId: state.id
				lineId: lineId
				quantity: parseInt quantity
				sellingPlanId: sellingPlanId
			else cart = await cartApi.deleteLine
				cartId: state.id
				lineId: lineId
			commit 'replace', cart
			commit 'close' if getters.itemCount == 0
		catch e then console.error e

	# Fetch the current cart status or start a new cart
	fetch: ({ commit, state }) ->
		cart = await getCart()
		commit 'replace', cart
		commit 'isHydrated' unless state.hydrated

	# Fetch the cart unless it is already hydrated
	fetchUnlessHydrated: ({ state, dispatch }) ->
		return if state.hydrated
		dispatch 'fetch'

	# Apply a discount code(s) to the cart
	applyDiscount: ({ state, dispatch, commit }, { code }) ->
		try
			await dispatch 'fetchUnlessHydrated'
			cart = await cartApi.updateDiscounts
				cartId: state.id
				codes: [ code ]
			commit 'replace', cart
		catch e then console.error e

	# Remove all discount codes
	removeDiscounts: ({ state, dispatch, commit }) ->
		try
			await dispatch 'fetchUnlessHydrated'
			cart = await cartApi.updateDiscounts
				cartId: state.id
				codes: [ ]
			commit 'replace', cart
		catch e then console.error e
