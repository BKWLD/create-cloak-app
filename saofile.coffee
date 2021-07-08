module.exports =

	prompts: -> [

		{ # Get project name
			name: 'name'
			message: 'What is the name of the new project?'
			default: this.outFolder
		}

		{ # Choose a CMS type
			name: 'cms'
			type: 'list'
			message: 'Which CMS are you using?'
			choices: [
				{ name: 'None', value: '' }
				{ name: 'Craft', value: 'craft' }
				{ name: 'Contentful', value: 'contentful' }
			]
		}

		{ # Is Shopify supported?
			name: 'shopify'
			type: 'confirm'
			message: 'Is this a hybrid Shopify site?'
			default: false
		}
	]

	actions: ({ answers: { cms, shopify } }) ->
		actions = []

		# Install nuxt-app to root if no other workspaces are needed
		if cms != 'craft' and !shopify
		then return [
			type: 'add'
			templateDir: 'template/nuxt-app'
			files: '**'
		]

		# Else, nuxt-app will be installed in a child directory
		else actions.push
			type: 'add'
			files: 'nuxt-app/**'

		# Add root level files since we're not writing nuxt-app to root
		actions.push
			type: 'add'
			files: '*'

		# Add craft-cms
		if cms == 'craft' then actions.push
			type: 'add'
			files: 'craft-cms/**'

		# Add shopify-theme
		if shopify then actions.push
			type: 'add'
			files: 'shopify-theme/**'

		# Return the final list of actions
		return actions
