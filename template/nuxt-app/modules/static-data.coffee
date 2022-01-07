###
Generate static JSON for use on Shopify so Craft server doesn't get hit with traffic. These also get used on Fallback URLs.
###
import { actions as globalsActions } from 'library/store/globals'
import { join, dirname } from 'path'
import { writeFileSync, mkdirSync } from 'fs'

# Register as Nuxt module
export default ->

	# Run syncing after generation is done, so we don't do it prematurely if
	# there is a generation fail
	@nuxt.hook 'generate:done', (generator, errors) ->

		# Don't run if there were errors
		return if errors.length

		# Don't run on deploy previews because those aren't loaded by Shopify
		# or by Craft preview mode
		return if process.env.NETLIFY and process.env.CONTEXT != 'production'

		# Generate the JSON
		generateStaticData outputDir: join generator.distPath, 'data'

# Do the actual generation work
export generateStaticData = ({ outputDir }) ->

	# Get data
	globals = await globalsActions.fetch()

	# Write files
	fileName = join outputDir, 'globals.json'
	mkdirSync dirname(fileName), recursive: true
	writeFileSync fileName, JSON.stringify globals
