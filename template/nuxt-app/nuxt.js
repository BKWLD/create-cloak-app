export default {

	modules: [

		// Cloak modules
		'@cloak-app/boilerplate',
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
		craft: {
			pageTypes: [
				'towers_towers_Entry'
				<%_ if (shopify) { _%>
				'products_products_Entry'
				<%_ } _%>
			]
		},
		visual: {
			srcsetWidths: [ 1920, 1440, 1024, 768, 425, 210 ],
			<%_ if (imgixHostname) { _%>
			imgixUrl: 'https://<%= imgixHostname %>',
			<%_ } _%>
		},
	},

}
