###
Boot up cart related logic
###
import { lazyHydrateCart } from 'library/services/cart/hydrate-cart'
export default ({ app, store }, inject) ->
	lazyHydrateCart store
