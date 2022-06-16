<!-- Standard Block renderer -->

<template lang='pug'>

.tower: blocks-list(:blocks='page.blocks')

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
<%_ if (cms == 'craft') { _%>
import pageMixin from '@cloak-app/craft/mixins/page'
<%_ } else if (cms == 'contentful') { _%>
# import pageMixin from '@cloak-app/contentful/mixins/page-mixin'
pageMixin = {} # Not implemented yet
<%_ } _%>
<%_ if (cms == 'craft' || cms == 'contentful') { _%>
import getTower from '~/queries/tower.gql'
<%_ } _%>

export default
	name: 'Tower'

	<%_ if (cms == 'craft' || cms == 'contentful') { _%>
	mixins: [ pageMixin ]
	<%_ } _%>

	# Get Tower data
	<%_ if (cms == 'craft') { _%>
	asyncData: ({ $craft, $notFound, params }) ->
	<%_ } else if (cms == 'contentful') { _%>
	asyncData: ({ $contentful, $notFound, params }) ->
	<%_ } else if (cms == '@nuxt/content') { _%>
	asyncData: ({ $notFound, params, $content }) ->
	<%_ } else { _%>
	asyncData: ({ params }) ->
	<%_ } _%>

		# Get data
		<%_ if (cms == 'craft') { _%>
		page = await $craft.getEntry
			query: getTower
			variables: uri: params.tower || '__home__'
		<%_ } else if (cms == 'contentful') { _%>
		page = await $contentful.getEntry
			query: getTower
			variables: path: params.tower || '__home__'
		<%_ } else if (cms == '@nuxt/content') { _%>
		page = await $content(params.tower || 'home').fetch()
		<%_ } else { _%>
		page = {} # Get page data from somewhere
		<%_ } _%>
		return $notFound() unless page

		# Set data
		return { page }

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

</style>
