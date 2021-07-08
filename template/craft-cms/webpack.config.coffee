# Deps
path = require 'path'
MiniCssExtractPlugin = require 'mini-css-extract-plugin'
module.exports =

	# Only rendering for production
	mode: 'production'

	# The main entry point
	entry: styles: './styles/index.styl'

	# Where to write files
	output:
		path: path.resolve __dirname, 'web'
		filename: '[name].js'

	# Loaders
	module:
		rules: [

			# Stylus
			{
				test: /\.styl(us)?$/,
				use: [
					MiniCssExtractPlugin.loader
					'css-loader'
					'stylus-loader'
				]
			}

		]

	# Outputting css
	plugins: [
		new MiniCssExtractPlugin filename: 'cp.css'
	]
