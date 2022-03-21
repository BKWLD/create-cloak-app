kebabCase = require 'lodash/kebabCase'
mapKeys = require 'lodash/mapKeys'
capitalize = require 'lodash/capitalize'
path = require 'path'
spawnAsync = require '@expo/spawn-async'
chalk = require 'chalk'
module.exports =

	# The questions asked of the user
	prompts: -> [

		{ # Get project name
			name: 'name'
			message: 'Project full name'
			default: this.outFolder
		}

		{ # Get the package name
			name: 'packageName'
			message: 'Project package name'
			default: ({ name }) -> kebabCase name
		}

		{ # Get the Sentry project name
			name: 'sentryProjectName'
			message: 'Sentry project name'
			default: ({ packageName }) -> packageName
		}

		{ # Get the Sentry DSN
			name: 'sentryDsn'
			message: 'Sentry DSN'
			when: ({ sentryProjectName }) -> !!sentryProjectName
		}

		{ # Choose a CMS type
			name: 'cms'
			type: 'list'
			message: 'CMS choice'
			choices: [
				{ name: 'Craft', value: 'craft' }
				{ name: 'Contentful', value: 'contentful' }
				{ name: '@nuxt/content', value: '@nuxt/content' }
				{ name: 'None of the above', value: false }
			]
		}

		{ # Get Contentful space id
			name: 'contentfulSpace'
			message: 'Contentful space ID'
			when: ({ cms }) -> cms == 'contentful'
		}

		{ # Get Contentful access token
			name: 'contentfulAccessToken'
			message: 'Contentful delivery API access token?'
			type: 'password'
			mask: '*'
			when: ({ cms }) -> cms == 'contentful'
		}

		{ # Get Contentful preview access token
			name: 'contentfulPreviewAccessToken'
			message: 'Contentful preview API access token?'
			type: 'password'
			mask: '*'
			when: ({ cms }) -> cms == 'contentful'
		}

		{ # Choose an image CDN provider
			name: 'imageCdn'
			type: 'list'
			message: 'Image CDN provider'
			choices: [
				{ name: 'Imgix', value: 'imgix' }
				{ name: 'None', value: false }
			]
		}

		{ # Collect imgix address
			name: 'imgixHostname'
			message: 'Imgix hostname'
			when: ({ imageCdn }) -> imageCdn == 'imgix'
			default: ({ packageName }) -> "#{packageName}.imgix.net"
		}

		{ # Is Shopify supported?
			name: 'shopify'
			type: 'confirm'
			message: 'Is hybrid Shopify site'
			default: false
			when: ({ cms }) -> cms == 'craft' # Only supporting Craft at the moment
		}

		{ # Name for Shopify themes
			name: 'firstName'
			message: 'Your first name, lowercase'
			when: ({ shopify }) -> shopify
		}

		{ # Get the Shopify dev hostname
			name: 'shopifyDevHostname'
			message: '[Dev store] Shopify public hostname'
			when: ({ shopify }) -> shopify
			default: ({ packageName }) -> "dev-shop.#{packageName}.bukwild.com"
		}

		{ # Get the myshopify.com dev hostname
			name: 'shopifyDevMyShopifyHostname'
			message: '[Dev store] Shopify internal myshopify.com hostname'
			when: ({ shopify }) -> shopify
			default: ({ packageName }) -> "#{packageName}-dev.myshopify.com"
		}

		{ # Get Shopify dev API key used for theme publishing
			name: 'shopifyDevApiPassword'
			message: '[Dev store] Bukwild Connect\'s Admin API password'
			type: 'password'
			mask: '*'
			when: ({ shopify }) -> shopify
		}

		{ # Get Shopify dev Storefont API token
			name: 'shopifyDevStorefrontToken'
			message: '[Dev store] Bukwild Connect\'s Storefront API access token'
			type: 'password'
			mask: '*'
			when: ({ shopify }) -> shopify
		}

		{ # Get the Nuxt dev hostname
			name: 'nuxtDevHostname'
			message: '[Dev store] Nuxt app\'s dev hostname'
			when: ({ shopify }) -> shopify
			default: ({ packageName }) -> "dev-www.#{packageName}.bukwild.com"
		}

		{ # Get the Shopify prod hostname
			name: 'shopifyProdHostname'
			message: '[Prod store] Shopify public hostname'
			when: ({ shopify }) -> shopify
			default: ({ packageName }) -> "prod-shop.#{packageName}.bukwild.com"
		}

		{ # Get the myshopify.com prod hostname
			name: 'shopifyProdMyShopifyHostname'
			message: '[Prod store] Shopify internal myshopify.com hostname'
			when: ({ shopify }) -> shopify
			default: ({ packageName }) -> "#{packageName}.myshopify.com"
		}

		{ # Get Shopify prod API key used for theme publishing
			name: 'shopifyProdApiPassword'
			message: '[Prod store] Bukwild Connect\'s Admin API password'
			type: 'password'
			mask: '*'
			when: ({ shopify }) -> shopify
		}

		{ # Get Shopify prod Storefont API token
			name: 'shopifyProdStorefrontToken'
			message: '[Prod store] Bukwild Connect\'s Storefront API access token'
			type: 'password'
			mask: '*'
			when: ({ shopify }) -> shopify
		}

		{ # Get the Nuxt prod hostname
			name: 'nuxtProdHostname'
			message: '[Prod store] Nuxt app\'s prod hostname'
			when: ({ shopify }) -> shopify
			default: ({ packageName }) -> "prod-www.#{packageName}.bukwild.com"
		}
	]

	# Assemble some additional shared data
	templateData: ->
		rootNuxtApp: rootNuxtApp @answers
		hasLibrary: hasLibrary @answers
		localCraftUrl: localCraftUrl @answers

		# Defaults for action specific vars
		loadFromLibrary: false

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
				'.editorconfig'
				'.sentryclirc'
				'.gitlab-ci.yml'
				'jsconfig.json'
				'package.json'
				'README.md'
			]
			filters:
				'jsconfig.json': !rootNuxtApp @answers

				# For pushing Shopify theme on git push
				'.gitlab-ci.yml': shopify

				# Used by shopify-theme webpack config
				'babel.config.json': shopify
				'postcss.config.js': shopify

		# nuxt-app paths that have template data
		nuxtTransformInclude = [
			'package.json'
			'README.md'
			'netlify.toml'
			'nuxt.config.coffee'
			'.env'
			'.env.example'
			'assets/app.styl'
			'components/layout/header/desktop.vue'
			'components/layout/header/mobile.vue'
			'components/blocks/copy.vue'
			'components/blocks/media-asset.vue'
			'components/blocks/spacer.vue'
			'components/blocks/wrapper.vue'
			'components/globals/blocks/list.vue'
			'queries/craft/craft-pages.gql'
			'plugins/components.coffee'
			'layouts/error.vue'
			'pages/_tower.vue'
			'store/globals.coffee'
		]

		# nuxt-app filter rules
		nuxtFilters =

			# Contentful only
			'components/globals/rich-text/*': answers.cms == 'contentful'

			# @nuxt/content only
			'content/*': answers.cms == '@nuxt/content'
			'static/imgs/*': answers.cms == '@nuxt/content'

			# CMSs with global data
			'store/*': answers.cms in ['craft', 'contentful']

			# Shopify-only
			'components/globals/smart-link.coffee': shopify
			'components/pages/pdp/marquee.vue': shopify
			'components/pages/pdp/cards-example.vue': shopify
			'pages/products/_product/_variant.vue': shopify
			'plugins/hydrate-cart.coffee': shopify
			'plugins/services.coffee': shopify
			'queries/craft/shopify-product.gql': shopify
			'queries/craft/pages/product.gql': shopify
			'queries/craft/fragments/product-card.gql': shopify
			'store/cart.coffee': shopify

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
				filters:

					# Product structures
					'entryTypes/products--*.yaml': shopify
					'sections/products--*.yaml': shopify


		# Add shopify-theme
		if shopify then actions.push
			type: 'add'
			files: 'shopify-theme/**'
			transformInclude: [
				'shopify-theme/.env'
				'shopify-theme/.env.example'
				'shopify-theme/config.yml'
				'shopify-theme/webpack.config.coffee'
			]

		# Is there a shared library package
		if hasLibrary answers
			actions.push # Copy all simple files
				type: 'add'
				files: 'library/**'
				transform: false
			actions.push # Move nuxt-app assets over to the library
				type: 'move'
				patterns:
					'nuxt-app/assets': 'library/assets'
					'nuxt-app/components/layout': 'library/components/layout'
					'nuxt-app/queries/globals.gql': 'library/queries/craft/globals.gql'
			actions.push # Restore nuxt-app's app.styl but have it load from library
				type: 'add'
				files: 'nuxt-app/assets/app.styl'
				templateData:
					hasLibrary: true
					loadFromLibrary: true

		# Move .gitignore files into place, which get ignored by npm pack
		actions.push
			type: 'move'
			patterns:
				'_gitignore': '.gitignore'
				'craft-cms/_gitignore': 'craft-cms/.gitignore'
				'nuxt-app/_gitignore': 'nuxt-app/.gitignore'
				'shopify-theme/_gitignore': 'shopify-theme/.gitignore'

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
			spawn = (cmd, args) => spawnAsync cmd, args,
				stdio: 'inherit'
				cwd: "#{@outDir}/craft-cms"

			# Install composer deps
			@logger.info 'Installing Craft Composer deps'
			await spawn 'composer', ['install']

			# Make Craft CLI executable
			@fs.chmodSync "#{@outDir}/craft-cms/craft", @fs.constants.S_IRWXU

			# Install Craft. I broke this up into multiple commands because I ran
			# into `No primary site exists` issues when running just `craft setup`.
			@logger.info 'Running Craft install'
			await spawn './craft', ['setup/app-id']
			await spawn './craft', ['setup/security-key']
			await spawn './craft', ['setup/db']
			@logger.info 'Setup your initial admin user'
			await spawn './craft', ['install', '--site-name=Site',
				'--site-url=$PRIMARY_SITE_URL', '--language=en-US']
			await spawn './craft', ['migrate/all', '--no-backup=1',
				'--interactive=0']
			await spawn './craft', ['update', 'craft', '--backup=0']
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
			spawn = (cmd, args) -> spawnAsync cmd, args,
				stdio: 'inherit'
				cwd: __dirname

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

		# Run Shopify mirgation steps
		if @answers.shopify

			# Make a spawn helper
			spawn = (cmd, args, options = {}) => spawnAsync cmd, args, {
				stdio: 'inherit'
				cwd: "#{@outDir}/shopify-theme"
				...options
			}

			# Create dev themes
			if @answers.shopifyDevApiPassword
				@logger.info 'Creating dev themes'
				await spawn 'theme', [
					'new'
					"--name=Dev"
					"--store=#{@answers.shopifyDevMyShopifyHostname}"
					"--password=#{@answers.shopifyDevApiPassword}"
				]
				@logger.info 'Creating dev store developer theme'
				await spawn 'theme', [
					'new'
					"--name=Developer: #{capitalize(@answers.firstName)}"
					"--store=#{@answers.shopifyDevMyShopifyHostname}"
					"--password=#{@answers.shopifyDevApiPassword}"
				]
				devThemes = (await spawn 'theme', [
					'get'
					'--list'
					"--store=#{@answers.shopifyDevMyShopifyHostname}"
					"--password=#{@answers.shopifyDevApiPassword}"
				], stdio: false).stdout

			# Create prod themes
			if @answers.shopifyProdApiPassword
				@logger.info 'Creating prod store public theme'
				await spawn 'theme', [
					'new'
					"--name=Prod"
					"--store=#{@answers.shopifyProdMyShopifyHostname}"
					"--password=#{@answers.shopifyProdApiPassword}"
				]
				@logger.info 'Creating prod store developer theme'
				await spawn 'theme', [
					'new'
					"--name=Developer: #{capitalize(@answers.firstName)}"
					"--store=#{@answers.shopifyProdMyShopifyHostname}"
					"--password=#{@answers.shopifyProdApiPassword}"
				]
				prodThemes = (await spawn 'theme', [
					'get'
					'--list'
					"--store=#{@answers.shopifyProdMyShopifyHostname}"
					"--password=#{@answers.shopifyProdApiPassword}"
				], stdio: false).stdout

		# Show next steps
		logBanner 'Done! Time for next steps:'
		docs = 'https://bukwild.slab.com/topics'

		# Show instructions to replace theme ids. I'm replacing the first line,
		# which is "Available theme versions:", with my own header
		if @answers.shopify
			if devThemes or prodThemes
				logStep 'Populate shopify-theme/config.yml'
			if devThemes
				console.log chalk.italic devThemes.replace /^.+/, 'Dev themes:'
			if prodThemes
				console.log chalk.italic prodThemes.replace /^.+/, 'Prod themes:'

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
		then logStep 'Configure & Deploy Craft', "#{docs}/rc0v20z4"

		# Add link to Netlify docs
		logStep 'Provision Netlify app', "#{docs}/f3fbea34"

		# Add links to Shopify docs
		if @answers.shopify
		then logStep 'Setup Custom Storefront Infrastructure', "#{docs}/9ll622ig"

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
	if step then console.log chalk.italic step

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
