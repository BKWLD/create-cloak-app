###
Inject global services and helpers into Nuxt
###
import * as storefront from 'library/services/shopify/storefront'
import helpers from 'library/helpers'
export default ({}, inject) ->

	# API Adapters
	inject 'storefront', storefront

	# Global helpers
	inject name, func for name, func of helpers
