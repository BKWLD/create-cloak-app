<!-- Standard Block renderer -->

<template lang='pug'>

.tower: blocks-list(:blocks='page.blocks')

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
import getCraftPages from '~/queries/craft-pages.gql'
import pageMixin from '@bkwld/cloak/mixins/page'

export default
	name: 'Tower'

	mixins: [ pageMixin ]

	# Get Tower data
	asyncData: ({ app, store, params, payload }) ->

		# Don't query for these paths
		return app.$notFound() if params.tower in [ '__webpack_hmr' ]

		# Get data
		[ page ] = payload || await app.$craft.getEntries
			query: getCraftPages
			variables:
				section: 'towers'
				type: 'towers'
				uri: params.tower || '__home__'
		return app.$notFound() unless page

		# Set data
		return { page }

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

</style>
