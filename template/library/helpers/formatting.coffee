###
Helpers related to formating values
###
import atob from 'atob-lite'
import btoa from 'btoa-lite'

# Format a string or number like money
export formatMoney = (val) -> '$' + twoDecimals val

# Format money for a product, which may be free
export productCost = (val) ->
	if parseFloat(val) == 0
	then 'Free'
	else formatMoney val

# Add two decimal places
export twoDecimals = (val) ->
	locale = navigator?.language || 'en-US'
	parseFloat(val).toLocaleString locale,
		minimumFractionDigits: 2
		maximumFractionDigits: 2

# Get the id from a Shoify gid:// style id.  This strips everything but the
# last part of the string.  So
# "gid://shopify/MailingAddress/34641879105581?accessToken=abc..."
# becomes "34641879105581"
export getShopifyId = (base64id) ->
	atob(base64id).match(/^gid:\/\/shopify\/\w+\/(\w+)/)?[1]

# Make a Shopify GID given a object type and id
export makeShopifyId = (type, id) ->
	btoa "gid://shopify/#{type}/#{id}"
