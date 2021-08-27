import RichText from '@bkwld/cloak/components/rich-text/rich-text'
import getEmbeddedEntry from './embedded-entry.gql'

# Add embeddable create calls to this switch statement
globalRenderer = ({ create, contentType, entry, key }) -> switch contentType

	# Make a button
	when "Button" then create 'btn', {
		key
		props: to: entry.url
	}, entry.text

# Extend Cloak's rich-text with custom embedded entries
export default
	functional: true

	# Use all of Cloak's rich-text's props
	props: {
		...RichText.props
	}

	# Render RichText with customer embeded entries query and renderer
	render: (create, { props, data }) ->
		create RichText, {
			...data
			props: {
				...props

				# Pass in project-specific query
				embededEntriesQuery: props.embededEntriesQuery or getEmbeddedEntry

				# Delegate rendering of embeded entries to components
				embededEntriesRenderer: props.embededEntriesRenderer or globalRenderer
			}
		}
