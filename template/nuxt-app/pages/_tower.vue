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
	<%_ if (cms == '@nuxt/content') { _%>
	asyncData: ({ app, params, $content }) ->
	<%_ } else { _%>
	asyncData: ({ app, params, payload }) ->
	<%_ } _%>

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
		<%_ } else if (cms == '@nuxt/content') { _%>
		page = await $content(params.tower || 'home').fetch()
		<%_ } _%>
		return app.$notFound() unless page

		# Set data
		return { page }

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

</style>
