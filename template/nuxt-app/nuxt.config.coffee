# Use Cloak to make boilerplate
{ mergeConfig, makeBoilerplate, isDev, isGenerating } = require '@bkwld/cloak'
boilerplate = makeBoilerplate
	siteName: '<%= name %>'
	<%_ if (sentryRepoName) { _%>
	repoName: '<%= sentryRepoName %>'
	<%_ } _%>
	<%_ if (cms) { _%>
	cms: '<%= cms %>'
	pageTypes: []
	<%_ } _%>

# Nuxt config
module.exports = mergeConfig boilerplate,

	# Add production internal URL
	anchorParser: internalUrls: [
		# /^https?:\/\/(www\.)?domain\.com/
	]
