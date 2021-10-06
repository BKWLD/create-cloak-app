<!-- Standard Block renderer -->

<template lang='pug'>

.tower: blocks-list(:blocks='page.blocks')

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
<%_ if (cms == 'craft') { _%>
import getCraftPages from '~/queries/craft-pages.gql'
<%_ } else if (cms == 'contentful') { _%>
import getTower from '~/queries/tower.gql'
<%_ } _%>
import pageMixin from '@bkwld/cloak/mixins/page'

export default
	name: 'Tower'

	mixins: [ pageMixin ]

	# Get Tower data
	asyncData: ({ app, store, params, payload }) ->

		# Don't query for these paths
		return app.$notFound() if params.tower in [ '__webpack_hmr' ]

		# Get data
		<%_ if (cms == 'craft') { _%>
		[ page ] = payload || await app.$craft.getEntries
			query: getCraftPages
			variables:
				section: 'towers'
				type: 'towers'
				uri: params.tower || '__home__'
		<%_ } else if (cms == 'contentful') { _%>
		page = payload || await app.$contentful.getEntry
			query: getTower
			variables: path: params.tower || '__home__'
		<%_ } _%>
		return app.$notFound() unless page

		# Set data
		return { page }

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

</style>
