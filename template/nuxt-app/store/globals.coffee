import getGlobals from '~/queries/globals.gql'

# Global data
export state = -> {}

export mutations =

	# Replace the whole state
	set: (state, data) -> Object.assign state, data

export actions =

	# Fetch global data
	fetch: ({ commit }) ->
		<%_ if (cms == 'craft') { _%>
		commit 'set', await @$craft.execute query: getGlobals
		<%_ } else if (cms == 'contentful') { _%>
		commit 'set', await @$contentful.getEntry query: getGlobals
		<%_ } _%>
