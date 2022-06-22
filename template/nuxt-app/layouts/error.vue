<!-- Custom error page -->

<template lang='pug'>

.error-page: template(v-if='!$fetchState.pending')

	//- Use blocks to render page
	blocks-list(v-if='page' :blocks='page.blocks')

	//- Or show simple message
	h1.style-h1(v-else) {{ message }}

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
<%_ if (cms == 'craft') { _%>
import pageMixin from '@cloak-app/craft/mixins/page'
<%_ } else if (cms == 'contentful') { _%>
# TODO
# import pageMixin from '@cloak-app/contentful/mixins/page-mixin'
pageMixin: {}
<%_ } _%>
<%_ if (cms == 'craft' || cms == 'contentful') { _%>
import getTower from '~/queries/tower.gql'
<%_ } _%>

export default
	name: 'Error'

	<%_ if (cms == 'craft' || cms == 'contentful') { _%>
	mixins: [ pageMixin ]
	<%_ } _%>

	props: ['error']

	data: ->
		page: null
		redirects: []

	fetch: ->

		# Get get the tower data
		<%_ if (cms == 'craft') { _%>
		@page = await @$craft.getEntry
			query: getTower
			variables: { @uri }
		<%_ } else if (cms == 'contentful') { _%>
		@page = await app.$contentful.getEntry
			query: getTower
			variables: route: @uri
		<%_ } _%>

		<%_ if (cms == 'craft') { _%>
		# Fetch all of the redirects, in case this page should normally client side
		# redirect.
		if @$config.cloak.craft.generateRedirects
		then @redirects = await @$craft.getEntries query: '''
			query getRedirects($site:[String]) {
				entries(site:$site, type:"redirects") {
					... on redirects_redirects_Entry {
						from: redirectFrom
						to: redirectTo
					}
				}
			}
		'''
		<%_ } _%>

	# Show Sentry user input dialog if an error
	mounted: -> @showSentryDialog() if @uri == 'error'

	computed:

		# Figure out which error Tower to show
		uri: -> switch @error?.statusCode
			when 404 then 'page-not-found'
			else 'error'

		# Simple error message
		message: -> switch @error?.statusCode
			when 404 then 'Page Not Found'
			else 'An Error Occured'

	watch:

		# When redirects is set (which may be after mounted when SPAing)
		redirects:
			immediate: true
			handler: -> @redirectIfMatch()

	methods:

		# If the current path matches the redirect "from", then redirect
		redirectIfMatch: ->
			if match = @redirects.find ({ from }) => from == @$route.path
			then location.href = match.to

		# Show the sentry dialog
		# https://docs.sentry.io/enriching-error-data/user-feedback/?platform=browser
		showSentryDialog: -> @$defer => @$sentry?.showReportDialog()

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>


</style>
