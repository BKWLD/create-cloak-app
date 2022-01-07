# Use Cloak to make boilerplate
{ mergeConfig, makeBoilerplate, isDev, isGenerating } = require '@bkwld/cloak'
boilerplate = makeBoilerplate
	siteName: '<%= name %>'
	<%_ if (cms) { _%>
	cms: '<%= cms %>'
	<%_ if (cms == 'craft') { _%>
	pageTypes: [
		'towers_towers_Entry'
		<%_ if (shopify) { _%>
		'products_products_Entry'
		<%_ } _%>
	]
	<%_ } else if (cms == 'contentful') { _%>
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

	<%_ if (shopify) { _%>
	env:
		SHOPIFY_URL: process.env.SHOPIFY_URL
		SHOPIFY_STOREFRONT_TOKEN: process.env.SHOPIFY_STOREFRONT_TOKEN
	<%_ } _%>


	buildModules: [
		<%_ if (cms == 'craft') { _%>
		'@bkwld/cloak/build/craft-netlify-redirects.js'
		<%_ } _%>
		<%_ if (shopify) { _%>
		'~/modules/compiled/ssg-variants.js'
		'~/modules/compiled/static-data.js'
		<%_ } _%>
	]

	modules: [
		<%_ if (cms == '@nuxt/content') { _%>
		'@nuxt/content'
		<%_ } _%>
		'vue-unorphan/nuxt/module'
		'vue-balance-text/nuxt/module'
	]

	plugins: [
		{ src: 'plugins/components' }
		<%_ if (shopify) { _%>
		{ src: 'plugins/services' }
		<%_ } _%>
	]

	<%_ if (hasLibrary) { _%>
	# External code that needs transpiling
	build: transpile: [
		/^library\/.+/ # Library workspace files
	]
	<%_ } _%>

	# Expect specially slug-ed towers to exist that will be loaded by error.vue
	generate: fallback: true

	# Add production internal URL
	anchorParser:
		<%_ if (shopify) { _%>
		disableSmartLinkRegistration: true
		<%_ } _%>
		internalUrls: [
			# /^https?:\/\/(www\.)?domain\.com/
		]

	<%_ if (hasLibrary) { _%>
	# Load source icons from library
	iconFont: files: ['../library/assets/fonts/fontagon/*.svg']
	<%_ } _%>
