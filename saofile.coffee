kebabCase = require 'lodash/kebabCase'
mapKeys = require 'lodash/mapKeys'
path = require 'path'
spawnAsync = require '@expo/spawn-async'
chalk = require 'chalk'
module.exports =

	# The questions asked of the user
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
			message: 'What is the full (not slugified) GitLab organization for the project?'
		}

		{ # Get the GitLab project organization
			name: 'sentryRepoName'
			message: 'What is the full (not slugified) GitLab name for the project?'
			when: ({ organization }) -> !!organization
			default: ({ name }) -> name
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

		{ # Get Contentful space id
			name: 'contentfulSpace'
			message: 'What is your Contentful Space ID?'
			when: ({ cms }) -> cms == 'contentful'
		}

		{ # Get Contentful token id
			name: 'contentfulAccessToken'
			message: 'What is your Contentful Access Token?'
			when: ({ cms }) -> cms == 'contentful'
		}

		{ # Is Shopify supported?
			name: 'shopify'
			type: 'confirm'
			message: 'Is this a hybrid Shopify site?'
			default: false
		}
	]

	# Assemble some additional shared data
	templateData: ->
		rootNuxtApp: rootNuxtApp @answers
		hasLibrary: hasLibrary @answers
		localCraftUrl: localCraftUrl @answers

	# Setup the template manipulation actions. I'm explicitly whitelisting
	# transformed files so it's easy to track where those are.
	actions: ({ answers }) ->
		{ cms, shopify } = answers
		actions = []

		# Always include root level files
		actions.push
			type: 'add'
			files: '*'
			transformInclude: [
				'package.json'
				'README.md'
			]

		# nuxt-app paths that have template data
		nuxtTransformInclude = [
			'package.json'
			'README.md'
			'nuxt.config.coffee'
			'.env'
			'.env.example'
			'components/layout/header/desktop.vue'
			'components/layout/header/mobile.vue'
			'components/blocks/copy.vue'
			'components/blocks/media-asset.vue'
			'components/blocks/spacer.vue'
			'components/blocks/wrapper.vue'
			'components/globals/blocks/list.vue'
			'pages/_tower.vue'
			'store/globals.coffee'
		]

		# nuxt-app filter rules
		nuxtFilters =
			'components/globals/rich-text/*': answers.cms == 'contentful'

		# Install nuxt-app to root if no other workspaces are needed and exit
		if rootNuxtApp answers
			actions.push # Copy all the files
				type: 'add'
				templateDir: 'template/nuxt-app'
				files: '**'
				transformInclude: nuxtTransformInclude
				filters: nuxtFilters
			actions.push # Merge gitignores
				type: 'modify'
				files: '_gitignore'
				handler: (data) =>
					rootGitignorePath = path.resolve __dirname, 'template/_gitignore'
					rootGitignore = @fs.readFileSync rootGitignorePath
					return rootGitignore + "\n" + data
			actions.push # Rename .gitignore
				type: 'move'
				patterns: '_gitignore': '.gitignore'
			installQueries actions, answers
			return actions

		# Else, nuxt-app will be installed in a child directory
		actions.push
			type: 'add'
			files: 'nuxt-app/**'
			transformInclude: nuxtTransformInclude.map (file) ->
				"nuxt-app/#{file}"
			filters: mapKeys nuxtFilters, (val, key) -> "nuxt-app/#{key}"

		# Copy the queries over
		installQueries actions, answers, 'nuxt-app/'

		# Add craft-cms
		if cms == 'craft'
			actions.push
				type: 'add'
				files: 'craft-cms/**'
				transform: false

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

		# Move .gitignore files into place, which get ignored by npm pack
		actions.push
			type: 'move'
			patterns:
				'_gitignore': '.gitignore'
				'craft-cms/_gitignore': 'craft-cms/.gitignore'
				'nuxt-app/_gitignore': 'nuxt-app/.gitignore'

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

			# Make a spawn helper
			spawn = (cmd, args) -> spawnAsync cmd, args,
				stdio: 'inherit'
				cwd: "#{@outDir}/craft-cms"

			# Install composer deps
			@logger.info 'Installing Craft Composer deps'
			await spawn 'composer', ['install']

			# Make Craft CLI executable
			@fs.chmodSync "#{@outDir}/craft-cms/craft", @fs.constants.S_IRWXU

			# Install Craft. I broke this up into multiple commands because I ran
			# into `No primary site exists` issues when running just `craft setup`
			@logger.info 'Running Craft install'
			await spawn './craft', ['setup/app-id']
			await spawn './craft', ['setup/security-key']
			await spawn './craft', ['setup/db']
			@logger.info 'Setup your initial admin user'
			await spawn './craft', ['install', '--site-name=Site',
				'--site-url=$PRIMARY_SITE_URL', '--language=en-US']
			await spawn './craft', ['migrate/all', '--no-backup=1',
				'--interactive=0']
			await spawn './craft', ['update', 'all', '--backup=0']
			await spawn 'yarn', ['build']

			# Link via Valet if installed
			{ status } = await spawn 'which', ['valet']
			unless status
				@logger.info 'Adding Valet link,
					you\'ll be asked for your OS user password'
				await spawn 'valet', ['link', @answers.packageName]
				cmsUrl = "http://#{@answers.packageName}.test"
				@logger.success "Craft CMS installed at #{cmsUrl}"

		# Run Contentful mirgation steps
		if @answers.cms == 'contentful'

			# Make a spawn helper
			spawn = (cmd, args) -> spawnAsync cmd, args, stdio: 'inherit'

			# Login to Contentful CLI
			@logger.info 'Logging into Contentful for running migrations'
			await spawn 'yarn', ['contentful', 'login']

			# Run migrations
			@logger.info 'Running migrations'
			migration = path.resolve __dirname, 'migrations/contentful/all.json'
			await spawn 'yarn', [
				'contentful'
				'space'
				'import'
				"--space-id=#{@answers.contentfulSpace}"
				"--content-file=#{migration}"
			]

		# Show next steps
		logBanner 'Done! Time for next steps:'
		docs = 'https://github.com/BKWLD/create-cloak-app/blob/main/docs'

		# Show link to run nuxt-app locally
		nuxtPath = if rootNuxtApp @answers
		then @outDir else "#{@outDir}/nuxt-app"
		logStep 'Run Hello World', "cd #{nuxtPath} && yarn dev --spa"

		# Show link to login to Craft CMS
		if @answers.cms == 'craft'
		then logStep 'Login to local CMS', localCraftUrl @answers

		# Show link to Contentful CMS
		if @answers.cms == 'contentful'
		then logStep 'Edit the starter Tower',
			"https://app.contentful.com/spaces/#{@answers.contentfulSpace}/entries?\
				contentTypeId=tower"

		# Add links to Craft docs
		if @answers.cms == 'craft'
		then logStep 'Configure & Deploy Craft', "#{docs}/craft-cms/config.md"

		# Add link to Netlify docs
		logStep 'Setup Netlify app', "#{docs}/netlify.md"

		# Add a trailing empty space
		console.log ''

# Should nuxt-app be installed at the root?
rootNuxtApp = ({ cms, shopify }) -> cms != 'craft' and !shopify

# Is there shared code in a library directory?
hasLibrary = ({ shopify }) -> !!shopify

# Make URL of local Craft install
localCraftUrl = ({ packageName}) -> "http://#{packageName}.test"

# Add a banner
logBanner = (text, color = 'green') ->
	console.log ''
	console.log chalk[color]('-'.repeat(text.length))
	console.log chalk[color](text)
	console.log chalk[color]('-'.repeat(text.length))

# Log a link
logStep = (label, step) ->
	console.log ''
	console.log chalk.bold label
	console.log chalk.italic step

# Install queries from the cms to the queries directory.  This requires a
# couple of steps
installQueries = (actions, answers, prefix = '') ->
	return unless answers.cms
	actions.push
		type: 'move'
		patterns: "#{prefix}queries": "#{prefix}queries.tmp"
	actions.push
		type: 'move'
		patterns: "#{prefix}queries.tmp/#{answers.cms}": "#{prefix}queries"
	actions.push
		type: 'remove'
		files: "#{prefix}queries.tmp"
