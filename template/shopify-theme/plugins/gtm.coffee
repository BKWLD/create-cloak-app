# Deps
import Vue from 'vue'
import ShopifyGtmInstrumentor from 'shopify-gtm-instrumentor'
import { addGtmCartSubscribers } from 'library/services/gtm/cart-events'
import { cookie } from 'library/helpers/storage'

# Setup GTM instrumentor
gtmEcomm = new ShopifyGtmInstrumentor
	debug: process.env.APP_ENV == 'dev'
	enableCheckoutEcommerceProperty: true

# Inject into components
Vue.prototype.$gtmEcomm = gtmEcomm

# Fire cart update events
addGtmCartSubscribers window.$store, gtmEcomm

# Fire checkout / purchase events
if step = window.Shopify?.Checkout?.step
	lineItems = window.CHECKOUT_FOR_GTM_INSTRUMENTOR
	gtmEcomm.checkout lineItems, step
	if step == 'thank_you' then gtmEcomm.purchase lineItems

# Inject a helper like the nuxt/gtm package
Vue.prototype.$gtm = push: (payload) ->
	window.dataLayer = [] unless window.dataLayer
	window.dataLayer.push payload
