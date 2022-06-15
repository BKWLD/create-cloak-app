export default {

	modules: [

		// Cloak modules
		'@cloak-app/boilerplate',
		'@cloak-app/copy',
		<%_ if (cms == 'craft') { _%>
		'@cloak-app/craft',
		<%_ } _%>
		<%_ if (shopify) { _%>
		'@cloak-app/shopify',
		<%_ } _%>
		'@cloak-app/visual',

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
			generateRedirects: true,
			pageTypes: [
				'towers_default_Entry'
				<%_ if (shopify) { _%>
				'products_product_Entry'
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

	// Always show logs (doesn't work from within module)
	build: { quiet: false },

}
