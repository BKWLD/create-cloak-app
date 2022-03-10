import * as storefront from 'library/services/shopify/storefront'
import { makeImgixUrl, nonEmpty } from '@bkwld/cloak/services/helpers'
import { getShopifyId, twoDecimals } from './formatting'
import getShopifyProductQuery from '~/queries/shopify-product.gql'
import memoize from 'lodash/memoize'

# Take an array of Craft product entries and merge Shopify data with them. This
# preserves the original order of the products.
export mergeShopifyProductCards = (products) ->
	return [] unless products.length

	# Get Shopify and bundle data for products. If Shopify data isn't found,
	# an exception is thrown, which we catch and use to remove that product
	# from the listing.
	products = await Promise.all products.map (product) ->
		try await mergeShopifyProductCard product
		catch error then console.warn error

	# Remove all empty products (those that errored while getting data)
	return nonEmpty products

# Merge Shopify data into a single card
export mergeShopifyProductCard = memoize (product) ->
	return unless product

	# Merge Shopify data into the product object
	shopifyProduct = await getShopifyProductByHandle product.slug
	product = { ...product, ...shopifyProduct }

	# Remove keys not needed for cards
	delete product.description

	# Return the final product
	return product

# Use the id and the collection showHidden modifier of the product as memoize
# resolver.  The latter was needed because a product would have that on some
# collections but not others.
, (product) -> product?.id

# Get the Shopify product data given a Shopify product handle
getShopifyProductByHandle = (productHandle) ->

	# Query Storefront API
	{ product } = await storefront.execute
		query: getShopifyProductQuery
		variables: handle: productHandle
	unless product then throw "No Shopify product found for #{productHandle}"

	# Add URLs to each variant for easier iteration later
	product.variants = product.variants.map (variant) =>
		variantIdNum = getShopifyId variant.id
		url = "/products/#{productHandle}/#{variantIdNum}"
		return { ...variant, url }

	# Return the product
	return product
