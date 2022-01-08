###
Send GTM dataLayer events in response to cart actions
###

# Main function that adds the subscribers
export addGtmCartSubscribers = (store, gtmEcomm) ->

	# Delegate relevant actions
	store.subscribeAction
		before: ({ type, payload }) -> switch type
			when 'cart/addItem' then fireAddItem payload
			when 'cart/updateLine' then fireUpdateItem payload
		after: ({ type, payload }) -> switch type
			when 'cart/addItem', 'cart/updateLine'
			then gtmEcomm.cartUpdated store.state.cart.id

	# Item added to cart
	fireAddItem = ({ id, quantity }) -> gtmEcomm.addToCart id, quantity

	# Item quantity updated
	fireUpdateItem = ({ id: lineItemId, quantity }) ->
		lineItem = getLineItem lineItemId
		diff = quantity - lineItem.quantity
		return if diff == 0
		if diff > 0
		then gtmEcomm.addToCart lineItem.variant.id, diff
		else gtmEcomm.removeFromCart lineItem.variant.id, Math.abs diff

	# Lookup the line item
	getLineItem = (lineItemId) ->
		lineItem = store.state.cart.lines.find (lineItem) ->
			lineItem.id == lineItemId
		unless lineItem then throw "Variant not found: #{variantGid}"
		return lineItem
