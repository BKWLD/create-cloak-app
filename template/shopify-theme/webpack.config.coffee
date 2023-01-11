# Deps
path = require 'path'
fs = require 'fs'
VueLoaderPlugin = require 'vue-loader/lib/plugin'
Dotenv = require 'dotenv-webpack'
TerserJSPlugin = require 'terser-webpack-plugin'
OptimizeCSSAssetsPlugin = require 'optimize-css-assets-webpack-plugin'
WebpackRequireFrom = require 'webpack-require-from'
MiniCssExtractPlugin = require 'mini-css-extract-plugin'

# Check if a dev build
isDev = process.env.NODE_ENV != 'production'
hmr = process.argv[1].includes 'webpack-dev-server'
port = 8080

<%_ if (imgixHostname) { _%>
# Hardcoded ENV values
process.env.IMGIX_URL = 'https://<%= imgixHostname %>'
<%_ } _%>

# Only extract CSS when building for prod
rootStyleLoader = if isDev then 'vue-style-loader' else
	loader: MiniCssExtractPlugin.loader
	options: { hmr }

# Shared babel config
babelLoader =
	loader: 'babel-loader'
	options: rootMode: 'upward' # Used by monorepos

# Create the Liquid snippets that sets vars needed to switch the asset load
# to support HMR
fs.writeFileSync path.join(__dirname, 'snippets/is-hmr.liquid'),
	if hmr then 'true' else ''
fs.writeFileSync path.join(__dirname, 'snippets/is-dev.liquid'),
	if isDev then 'true' else ''

# Webpack config
module.exports =
	mode: process.env.NODE_ENV || 'development'

	# The main entry point
	entry:
		main: './main.coffee'
		checkout: './checkout.coffee'

	# Mimize extracted CSS and redeclare the JS minimizer
	optimization: minimizer: [

		# Need to manually enable sourcemaps for prod
		# https://github.com/webpack-contrib/terser-webpack-plugin/tree/v4.2.3#sourcemap
		new TerserJSPlugin sourceMap: true

		# Need to manually enable sourcemaps for prod
		# https://github.com/NMFR/optimize-css-assets-webpack-plugin/issues/53#issuecomment-400294569
		new OptimizeCSSAssetsPlugin cssProcessorOptions: map:
			inline: false
			annotation: true
	]

	# Where to write files
	output:
		path: path.resolve __dirname, 'assets'
		publicPath: if hmr then "https://localhost:#{port}/assets/" else ''
		filename: 'dist-[name].js'
		chunkFilename: 'dist-[chunkhash].js'

	# Configure what shows up in the terminal output
	stats:
		children:     false # Hides the "extract-text-webpack-plugin" messages
		assets:       true
		colors:       true
		version:      false
		hash:         false
		timings:      true
		chunks:       false
		chunkModules: false
		modules:      false # Just the outputted files

	# Don't generate source maps on dev because we don't want to have to wait
	# for them to upload to Shopify
	devtool: if isDev then false else 'source-map'

	# Allow dev server to be on a different host than test domain
	# https://github.com/webpack/webpack-dev-server/issues/533
	devServer:
		hot: hmr
		headers: 'Access-Control-Allow-Origin': '*'
		quiet: true
		disableHostCheck: true
		compress: true
		port: port
		https: true

	module:
		rules: [

			# Vue components
			{
				test: /\.vue$/
				loader: 'vue-loader'
			}

			# Coffeescript
			{
				test: /\.coffee$/
				use: [
					babelLoader
					'coffee-loader'
				]
			}

			# JS through Babel
			{
				test: /\.js$/,
				use: [babelLoader]
			}

			# Stylus
			{
				test: /\.styl(us)?$/,
				use: [
					rootStyleLoader
					'css-loader'
					'postcss-loader'
					{
						loader: 'stylus-loader'
						options: import: path.resolve __dirname,
							'../library/assets/definitions.styl'
					}
				]
			}

			# CSS
			{
				test: /\.css$/,
				use: [
					rootStyleLoader
					'css-loader'
					'postcss-loader'
				]
			}

			# Pug
			{
				test: /\.pug$/
				loader: 'pug-plain-loader'
			}

			# Graphql
			{
				test: /\.gql?$/
				loader: 'webpack-graphql-loader'
			}

			# Font Files
			{
				test: /\.(eot|ttf|otf|woff|woff2)(\?\S*)?$/i
				loader: 'file-loader?name=dist-[name]-[hash:6].[ext]'
			}

			# Image Files
			{
				test: /\.(png|jpe?g|gif|svg|webp)$/i
				loader: 'url-loader'
				options:
					limit: 1000
					name: 'dist-[name]-[hash:6].[ext]'
			}
		]

	resolve:
		alias:
			vue$: "vue/dist/vue.esm.js"
			'~': path.resolve __dirname, '../nuxt-app'
		extensions: [".js", ".vue", ".coffee", ".json"]

	plugins: [
		new VueLoaderPlugin()
		new Dotenv systemvars: true

		# Build external CSS file
		new MiniCssExtractPlugin
			filename: 'dist-[name].css'
			chunkFilename: 'dist-[chunkhash].css'

		# Works with config in theme.liquid to prepend the Shopify CDN path
		new WebpackRequireFrom
			variableName: 'cdnUrl' unless hmr

			# Prevent logging errors from CSS
			# See https://github.com/agoldis/webpack-require-from/pull/28
			suppressErrors: true

	# Remove null entries
	].filter (val) -> !!val
