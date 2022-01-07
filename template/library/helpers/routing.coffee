###
Helpers related to making URLs
###
import once from 'lodash/once'
import { SHOPIFY_ROOT_PATHS } from './constants'

# Determine if the URL is a Shopify URL
isShopifyRegex = new RegExp "^\/(#{SHOPIFY_ROOT_PATHS.join('|')})", 'i'
export isShopifyUrl = (url) ->

	# example url: /account or /
	return isShopifyRegex.test url

# Determine if the URL is a Nuxt URL
export isNuxtUrl = (url) -> not isShopifyUrl url

# Make a Shopify URL
export makeShopifyUrl = (url) ->
	urlObj = new URL url, process.env.SHOPIFY_URL
	urlObj.host = getShopifyHost()
	return urlObj.toString()

# Get the Nuxt app host
export getShopifyHost = once -> (new URL process.env.SHOPIFY_URL).host

# Make a Nuxt URL
export makeNuxtUrl = (url) ->
	urlObj = new URL url, getNuxtAppUrl()
	urlObj.host = getNuxtAppHost()
	return urlObj.toString()

# Get the host for the nuxt app, which may vary based on the current URL
export getNuxtAppUrl = once -> process.env.NUXT_APP_URL || process.env.URL

# Get the Nuxt app host
export getNuxtAppHost = once -> (new URL getNuxtAppUrl()).host

# Get the current apex (root) domain
export currentApexDomain = ->
	location.hostname.match(/(?:^|\.)((?:[^.]+\.)?[^.]+)$/)[1]
