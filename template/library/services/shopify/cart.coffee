###
Helpers for interacting with cart APIs
###
import fetchQuery from 'library/queries/shopify/cart/fetch.gql'
import createQuery from 'library/queries/shopify/cart/create.gql'
import addQuery from 'library/queries/shopify/cart/add.gql'
import updateQuery from 'library/queries/shopify/cart/update.gql'
import deleteQuery from 'library/queries/shopify/cart/delete.gql'
import discountsQuery from 'library/queries/shopify/cart/discounts.gql'
import { execute, findEdgeNodes } from './storefront'

# Throw errors if found in the response, else map the checkout object
handleCheckoutMutation = ({ mutation: response }) ->
	if response.userErrors?.length
	then throw JSON.stringify response.userErrors
	return response.cart

# Lookup a checkout
export fetch = (id) ->
	{ cart } = await execute
		query: fetchQuery
		variables: { id }
	return cart

# Create a new checkout
export create = ->
	handleCheckoutMutation await execute
		query: createQuery
		variables: input: {}

# Add an item to the checkout
export addVariant = ({ cartId, variantId, quantity, sellingPlanId }) ->
	handleCheckoutMutation await execute
		query: addQuery
		variables:
			cartId: cartId
			lines: [
				merchandiseId: variantId
				quantity: quantity
				sellingPlanId: sellingPlanId
			]

# Update a line item
export updateLine = ({ cartId, lineId, quantity, sellingPlanId }) ->
	handleCheckoutMutation await execute
		query: updateQuery
		variables:
			cartId: cartId
			lines: [
				id: lineId
				quantity: quantity
				sellingPlanId: sellingPlanId
			]

# Update a line item
export deleteLine = ({ cartId, lineId }) ->
	handleCheckoutMutation await execute
		query: deleteQuery
		variables:
			cartId: cartId
			lines: [ lineId ]

# Update discount codes
export updateDiscounts = ({ cartId, codes }) ->
	handleCheckoutMutation await execute
		query: discountsQuery
		variables:
			cartId: cartId
			discountCodes: codes
