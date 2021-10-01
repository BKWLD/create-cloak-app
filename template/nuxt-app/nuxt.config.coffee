# Use Cloak to make boilerplate
{ mergeConfig, makeBoilerplate, isDev, isGenerating } = require '@bkwld/cloak'
boilerplate = makeBoilerplate
	siteName: '<%= name %>'
	<%_ if (cms) { _%>
	cms: '<%= cms %>'
	<%_ if (cms == 'craft') { _%>
	pageTypes: [ 'towers_towers_Entry' ]
	<%_ } else { _%>
	pageTypes: pageTypes: [
		{
			contentType: 'tower'
			routeField: 'path'
			route: (path) -> if path == '__home__' then '/' else "/#{path}"
		}
	]
	<%_ } _%>
	<%_ } _%>
	srcsetWidths: [ 1920, 1440, 1024, 768, 425, 210 ]

# Nuxt config
module.exports = mergeConfig boilerplate,

	<%_ if (cms == 'craft') { _%>
	buildModules: [
		'@bkwld/cloak/build/craft-netlify-redirects.js'
	]
	<%_ } _%>

	modules: [
		'vue-unorphan/nuxt/module'
		'vue-balance-text/nuxt/module'
	]

	# Expect specially slug-ed towers to exist that will be loaded by error.vue
	generate: fallback: true

	# Add production internal URL
	anchorParser: internalUrls: [
		# /^https?:\/\/(www\.)?domain\.com/
	]

