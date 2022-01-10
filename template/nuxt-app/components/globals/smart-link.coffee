import SmartLink from 'vue-routing-anchor-parser/smart-link'
import { isShopifyUrl, makeShopifyUrl } from 'library/helpers/routing'

# Make component by destructuring vue-routing-anchor-parser version
export default {

	# Inherit defaults
	...SmartLink

	# Destructure the props and data we care about
	render: (create, context) ->

		# If a Shopify URL, make an anchor with that domain
		if isShopifyUrl to = context.props.to
			makeAnchor create, context, makeShopifyUrl to

		# Else do default smart link logic
		else SmartLink.render create, context
}

# Create a normal anchor while expecting a `to` prop
export makeAnchor = (create, context, url = null) ->
	{ data, props: { to }, children } = context
	href = url || to

	# Append the preview_theme_id if configured
	if themeId = process.env.SHOPIFY_PREVIEW_THEME_ID
		href += if href.includes '?' then '&' else '?'
		href += "preview_theme_id=#{themeId}"

	# Make the anchor tag
	create 'a', {
		...data
		attrs: { ...data.attrs, href }
	}, children
