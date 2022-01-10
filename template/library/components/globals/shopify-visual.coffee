# Load cloak-visual
import CloakVisual, { resizeWidths } from '@bkwld/cloak/components/cloak-visual'

# Map Craft image objects into params for visual
export default
	name: 'CraftVisual'
	functional: true

	# Support all CloakVisual props
	props: {
		...CloakVisual.props

		# Only supporting Storefront API image objects
		# https://shopify.dev/api/storefront/reference/common-objects/image
		image: Object
	}

	# Render a Visual instance
	render: (create, { props, data, children, scopedSlots }) ->

		# Get reference to the image object
		image = props.image

		# Get the image src, ignoring srcset for now.
		imageUrl = if props.natural
		then image?.src
		else makeShopifyImageUrl image?.src, resizeWidths[0]

		# Figure out the aspect ratio
		aspect = switch
			when props.aspect is false then undefined
			when !props.aspect? then image?.width / image?.height
			else props.aspect

		# Passthrough the width and height
		{ width, height } = if props.natural and image then image else props

		# Apply a max-width if no upscale is set
		maxWidth = if props.noUpscale then image?.width

		# Instantiate a Visual instance
		create CloakVisual, {
			...data
			props: {

				# Passthrough props by default
				...props

				# Image
				image: imageUrl
				srcset: makeSrcset image, webp: false, max: width || maxWidth

				# Layout
				aspect
				width
				height
				maxWidth

				# Accessibility
				alt: image?.altText

		# Passthrough slot
		}}, children

# The srcset values need to match those used in transforms in the query
export makeSrcset = (image, { max } = {}) ->
	return unless image

	# Don't output src options that are greater then a 2X version of the max width
	sizes = unless max then resizeWidths
	else
		maxWidth = 2 * parseInt max
		resizeWidths.filter (size) -> size <= maxWidth

	# Make the srcset string
	sizes.map (size) ->
		"#{encodeURI(makeShopifyImageUrl(image.src, size))} #{size}w"

	# Filter out empties
	.filter (val) -> !!val
	.join ','

# Make a Shopify image url
makeShopifyImageUrl = (url, width = '', height = '') ->
	if width || height
	then url?.replace /(\.(png|jpe?g|gif|svg))/, "_#{width}x#{height}$1"
	else url # If no width or height specified, return original image
