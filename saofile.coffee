kebabCase = require 'lodash/kebabCase'
path = require 'path'
spawn = require '@expo/spawn-async'
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

		# { # Craft DB host
		# 	name: 'dbHost'
		# 	message: 'What is your local mysql host?'
		# 	default: '127.0.0.1'
		# 	when: ({ cms }) -> cms == 'craft'
		# }

		# { # Craft DB name
		# 	name: 'dbName'
		# 	message: 'What is your local mysql database for this project?'
		# 	default: ({ packageName }) -> packageName
		# 	when: ({ cms }) -> cms == 'craft'
		# }

		# { # Craft DB username
		# 	name: 'dbUser'
		# 	message: 'What is your local mysql username?'
		# 	default: 'root'
		# 	when: ({ cms }) -> cms == 'craft'
		# }

		# { # Craft DB password
		# 	name: 'dbPass'
		# 	message: 'What is your local mysql password?'
		# 	when: ({ cms }) -> cms == 'craft'
		# }

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
			transformInclude: 'craft-cms/.env'

		# Add shopify-theme
		if shopify then actions.push
			type: 'add'
			files: 'shopify-theme/**'
			transform: false

		# Is there a shared library package
		if hasLibrary answers then actions.push
			type: 'add'
			files: 'library/**'
			transform: false

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

	# Things that run after fiels are copied over
	completed: ->

		# Init git repo
		@gitInit()

		# Install yarn deps
		await @npmInstall()

		# Run Craft installation steps
		if @answers.cms == 'craft'

			# Install composer deps
			@logger.info 'Installing Craft Composer deps'
			await spawn 'composer', ['install'],
				stdio: 'inherit'
				cwd: "#{@outDir}/craft-cms"

			# Install Craft
			@logger.info 'Running Craft install'
			@fs.chmodSync "#{@outDir}/craft-cms/craft", @fs.constants.S_IRWXU
			await spawn './craft', ['setup'],
				stdio: 'inherit'
				cwd: "#{@outDir}/craft-cms"

			# Link via Valet if installed
			{ status } = await spawn 'which', ['valet']
			unless status
				@logger.info 'Adding Valet link,
					you\'ll be asked for your OS user password'
				await spawn 'valet', ['link', @answers.packageName],
					stdio: 'inherit'
					cwd: "#{@outDir}/craft-cms"
				cmsUrl = "http://#{@answers.packageName}.test"
				@logger.success "Craft CMS installed at #{cmsUrl}"

# Should nuxt-app be installed at the root?
rootNuxtApp = ({ cms, shopify }) -> cms != 'craft' and !shopify

# Is there shared code in a library directory?
hasLibrary = ({ shopify }) -> !!shopify
