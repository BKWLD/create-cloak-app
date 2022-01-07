###
Build a client for querying the Shopify Storefront API
###
import axios from 'axios'
import mapValues from 'lodash/mapValues'
import isPlainObject from 'lodash/isPlainObject'
import productCardFragment from 'library/queries/shopify/fragments/product-card.gql'

# Error object with custom handling
class StorefrontError extends Error
	name: 'StorefrontError'
	constructor: (errors, payload) ->
		super errors.map((e) -> e.debugMessage || e.message).join ', '
		@errors = errors.map (e) -> JSON.stringify e
		@payload = payload

# Run an API query
export execute = (payload) ->
	response = await axios
		url: "#{process.env.SHOPIFY_URL}/api/2021-10/graphql"
		method: 'post'
		headers:
			'Accept': 'application/json'
			'Content-Type': 'application/json'
			'X-Shopify-Storefront-Access-Token': process.env.SHOPIFY_STOREFRONT_TOKEN

		# Should have query and maybe variables properties
		data: payload

	# Handle errors in response
	if response.data.errors
		throw new StorefrontError response.data.errors, payload

	# Return data
	return flattenEdges response.data.data

# Recurse through an object and flatten eddge/node levels
flattenEdges = (obj) ->

	# If an array, act on all members
	if Array.isArray obj then return obj.map flattenEdges

	# If not an object, return self
	return obj unless isPlainObject obj

	# Loop through object properties
	mapValues obj, (val, key) ->

		# If there is an "edges" child, flatten it's contents
		if val?.edges
		then val = val.edges.map ({ node }) -> node

		# Recurse deeper
		flattenEdges val

# Helper to look up product card data from their handles by querying the
# productByHandle method multiple times
export getProductCards = (handles) ->
	return [] unless handles?.length

	# Make the list of queries
	productQueries = handles.map (handle, index) -> """
		product_#{index}: productByHandle(handle:"#{handle}") {
			...productCard
		}
	"""

	# Assemble full query
	query = """
		query getProductCards {
			#{productQueries.join("\n")}
		}
		#{productCardFragment}
	"""

	# Execute the query and return only valid products
	products = await execute { query }

	# Nullcheck because result is `undefined` if no product hits
	return [] if !products? || typeof products != 'object'
	return onlyPublishedProducts Object.values products

# Return only products with URLs, aka, those that have been published to the
# online store. This only works on production because the URL value is null
# while the site is password protected.
# https://community.shopify.com/c/Shopify-APIs-SDKs/Product-onlineStoreUrl/m-p/572566/highlight/true#M38272
export onlyPublishedProducts = (products) ->
	products.filter (product) ->
		if process.env.APP_ENV == 'prod'
		then !!product?.onlineStoreUrl else !!product
