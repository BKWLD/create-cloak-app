###
Inject global services and helpers into Nuxt
###
import ShopifyGtmInstrumentor from 'shopify-gtm-instrumentor'
import * as storefront from 'library/services/shopify/storefront'
import helpers from 'library/helpers'
export default ({}, inject) ->

	# API Adapters
	inject 'storefront', storefront

	# Shopify GTM Instrumentor
	inject 'gtmEcomm', gtmEcomm = new ShopifyGtmInstrumentor
		debug: process.env.APP_ENV == 'dev'

	# Global helpers
	inject name, func for name, func of helpers
