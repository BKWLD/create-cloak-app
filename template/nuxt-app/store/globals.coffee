import getGlobals from '~/queries/globals.gql'

# Global data
export state = ->
	defaultSeo: null

export mutations =

	# Replace the whole state
	set: (state, data) -> Object.assign state, data

export actions =

	# Fetch global data
	fetch: ({ commit }) ->
		commit 'set', await @$craft.execute query: getGlobals
