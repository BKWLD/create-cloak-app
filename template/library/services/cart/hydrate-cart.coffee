###
Sync the current cart count with a cookie and only hydrate the cart when it's
viewed or updated
###
import { cookie } from 'library/helpers/storage'
import { CART_COUNT_KEY } from 'library/helpers/constants'
export lazyHydrateCart = (store) ->

	# Keep the cart count cookie up to date
	store.watch ((state, getters) -> getters['cart/itemCount'])
	, ((count) -> cookie.set CART_COUNT_KEY, count)

	# Call fetch when the cart/open is mutated
	store.subscribe (mutation, state) ->
		return unless mutation.type == 'cart/open'
		await store.dispatch 'cart/fetchUnlessHydrated'

	# Clear the cart count after checkout
	if location.pathname.match /\/checkouts\/[^\/]+\/thank_you$/
	then cookie.set CART_COUNT_KEY, 0
