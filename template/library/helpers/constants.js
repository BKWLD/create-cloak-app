/**
 * Settings and configs that are shared in multiple places
 */

// The root paths that are handled by Shopify. These get auto-redirected to.
export const SHOPIFY_ROOT_PATHS = [
	'cart',
	'pages',
	'apps',
	'\\w+\/checkouts',
	'\\w+\/orders',
	'challenge',
	'tools'
]

// Cookie name for the count of items in the cart
export const CART_COUNT_KEY = 'cartCount'

// Cookie name for the storefront api cart id
export const CART_ID_KEY = 'cartId'

// UTM query params
export const UTM_KEYS = [
	'utm_source',
	'utm_medium',
	'utm_campaign',
	'utm_term',
	'utm_content',
	'gclid',
]
