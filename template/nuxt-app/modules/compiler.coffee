###
A webpack config that can converts coffeescript into importable JS
###

# Deps
{ resolve } = require 'path'
Dotenv = require 'dotenv-webpack'

# Webpack config
module.exports =

	# Don't need any special compiling
	mode: 'none'

	# Support node internal references
	target: 'node'

	# Modules that need compiling
	entry:
		'ssg-variants': resolve __dirname, 'ssg-variants.coffee'
		'static-data': resolve __dirname, 'static-data.coffee'

	# Where to write files
	output:
		path: resolve __dirname, 'compiled'
		filename: '[name].js'
		libraryTarget: 'commonjs2' # Necessary to get import-able

	resolve:

		# Make .coffee optional
		extensions: ['.coffee', '.js']

		# Resolve tildes
		alias: '~': resolve __dirname, '../'

	# Add loaders
	module: rules: [

		# Coffeescript
		{
			test: /\.coffee$/,
			loader: 'coffee-loader'
		}

		# GraphQL
		{
			test: /\.gql?$/
			loader: 'webpack-graphql-loader'
		}
	]

	# Support dotenv
	plugins: [
		new Dotenv()
	]

	# Reduce the ouput
	stats: 'errors-only'
