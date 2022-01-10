###
Boot up cart related logic
###
import { addGtmCartSubscribers } from 'library/services/gtm/cart-events'
import { lazyHydrateCart } from 'library/services/cart/hydrate-cart'
export default ({ app, store }, inject) ->
	addGtmCartSubscribers store, app.$gtmEcomm
	lazyHydrateCart store
