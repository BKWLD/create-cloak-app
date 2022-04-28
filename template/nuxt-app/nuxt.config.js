export default {

	modules: [

		// Cloak modules
		'@cloak-app/boilerplate',
		'@cloak-app/visual',
		<%_ if (cms == 'craft') { _%>
		'@cloak-app/craft',
		<%_ } _%>
		<%_ if (shopify) { _%>
		'@cloak-app/shopify',
		<%_ } _%>

		// Other modules
		<%_ if (cms == '@nuxt/content') { _%>
		'@nuxt/content',
		<%_ } _%>
	],

	// Cloak settings
	cloak: {
		boilerplate: {
			siteName: '<%= name %>',
			// polyfills: ['default']
		},
		<%_ if (cms == 'craft') { _%>
		craft: {
			pageTypes: [
				'towers_towers_Entry'
				<%_ if (shopify) { _%>
				'products_products_Entry'
				<%_ } _%>
			]
		},
		<%_ } _%>
	},

	<%_ if (imgixHostname) { _%>
	// @nuxt/image settings
	image: {
		provider: 'imgix',
		domains: ['sfo3.digitaloceanspaces.com'],
		imgix: {
			baseURL: 'https://<%= imgixHostname %>',
		},
	},
	<%_ } _%>

}