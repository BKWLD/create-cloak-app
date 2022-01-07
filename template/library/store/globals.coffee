import axios from 'axios'
import getGlobals from 'library/queries/craft/globals.gql'
import { shouldUseStaticData, getNuxtAppUrl } from 'library/helpers/routing'
import { execute } from '@bkwld/cloak/services/craft'

# Global data
export state = ->
	defaultSeo: null

export mutations =

	# Replace the whole state
	set: (state, data) -> Object.assign state, data

export actions =

	# Fetch global data
	fetch: ({ commit } = {}) ->

		# Collect data
		data = await fetchCraftData()

		# This method is invoked by the static-data module and won't have a
		# commit function in that case
		if commit then commit 'set', data
		else return data

# Fetch the Craft global data, grabbing it from build json files when on
# prod shopify
fetchCraftData = ->
	if shouldUseStaticData()
		globalsUrl = "#{getNuxtAppUrl()}/data/globals.json"
		(await axios.get globalsUrl).data
	else await execute query: getGlobals
