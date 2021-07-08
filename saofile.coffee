kebabCase = require 'lodash/kebabCase'
path = require 'path'
module.exports =

	prompts: -> [

		{ # Get project name
			name: 'name'
			message: 'What is the full name of the new project?'
			default: this.outFolder
		}

		{ # Get the package name
			name: 'packageName'
			message: 'What should be the package name of the project?'
			default: ({ name }) -> kebabCase name
		}

		{ # Get the GitLab project organization
			name: 'organization'
			message: 'What is the GitLab organization for the project?'
		}

		{ # Get the GitLab project organization
			name: 'sentryRepoName'
			message: 'What is the GitLab full name for the project?'
			when: ({ organization }) -> !!organization
			default: ({ name, organization }) -> "#{organization} / #{name}"
		}

		{ # Choose a CMS type
			name: 'cms'
			type: 'list'
			message: 'Which CMS are you using?'
			choices: [
				{ name: 'Craft', value: 'craft' }
				{ name: 'Contentful', value: 'contentful' }
				{ name: 'None of the above', value: false }
			]
		}

		{ # Is Shopify supported?
			name: 'shopify'
			type: 'confirm'
			message: 'Is this a hybrid Shopify site?'
			default: false
		}
	]

	templateData: ->
		rootNuxtApp: rootNuxtApp this.answers
		hasLibrary: hasLibrary this.answers

	actions: ({ answers }) ->
		{ cms, shopify } = answers
		actions = []

		# Always include root level files
		actions.push
			type: 'add'
			files: '*'

		# Install nuxt-app to root if no other workspaces are needed and exit
		if rootNuxtApp answers
			actions.push # Copy all the files
				type: 'add'
				templateDir: 'template/nuxt-app'
				files: '**'
			actions.push # Merge gitgnores
				type: 'modify'
				files: '.gitignore'
				handler: (data) =>
					rootGitignorePath = path.resolve __dirname, 'template/.gitignore'
					rootGitignore = @fs.readFileSync rootGitignorePath
					return rootGitignore + "\n" + data
			return actions

		# Else, nuxt-app will be installed in a child directory
		else actions.push
			type: 'add'
			files: 'nuxt-app/**'

		# Add craft-cms
		if cms == 'craft' then actions.push
			type: 'add'
			files: 'craft-cms/**'

		# Add shopify-theme
		if shopify then actions.push
			type: 'add'
			files: 'shopify-theme/**'

		# Is there a shared library package
		if hasLibrary answers then actions.push
			type: 'add'
			files: 'library/**'

		# Populate yarn workspaces
		actions.push
			type: 'modify'
			files: 'package.json'
			handler: (json) ->
				if cms == 'craft' then json.workspaces.push 'craft-cms'
				if hasLibrary then json.workspaces.push 'library'
				if shopify then json.workspaces.push 'shopify-theme'
				json.workspaces.sort()
				return json

		# Return the final list of actions
		return actions

	# Final steps
	completed: ->
		@gitInit()
		await @npmInstall()
		@showProjectTips()

# Should nuxt-app be installed at the root?
rootNuxtApp = ({ cms, shopify }) -> cms != 'craft' and !shopify

# Is there shared code in a library directory?
hasLibrary = ({ shopify }) -> !!shopify
