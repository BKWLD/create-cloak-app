<!-- Render all the typography styles -->

<template lang='pug'>

.style-guide.wysiwyg

	h1.header Typography
	.style-h1 <strong>h1</strong> Cras justo odio, dapibus ac facilisis in, egestas eget quam.
	.style-h2 <strong>h2</strong> Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum.
	.style-h3 <strong>h3</strong> Cras justo odio, dapibus ac facilisis in, egestas eget quam. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum.
	.style-h4 <strong>h4</strong> Curabitur blandit tempus porttitor. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Lorem ipsum dolor sit amet, consectetur adipiscing elit.
	.style-h5 <strong>h5</strong> Donec ullamcorper nulla non metus auctor fringilla. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.
	p <strong>p</strong> Etiam porta sem malesuada magna mollis euismod. Maecenas faucibus mollis interdum. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum. Donec ullamcorper nulla non metus auctor fringilla.

	h1.header Spacing
	.spacers
		.xl XL
		.l L
		.m M
		.s S
		.xs XS

	h1.header Colors
	.swatches
		.swatch
			.box.primary-color
			label primary-color
		.swatch
			.box.primary-color-dark
			label primary-color-dark
		.swatch
			.box.secondary-color
			label secondary-color
		.swatch
			.box.offwhite
			label offwhite
		.swatch
			.box.disabled-fill
			label disabled-fill
		.swatch
			.box.ui-border-color
			label ui-border-color
		.swatch
			.box.warning-color
			label warning-color

	h1.header Buttons
		.btn-wrap
			btn Primary Button
		.btn-wrap
			btn(disabled) Disabled Button

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
export default
	layout: 'none'

	# Disable indexing
	head: -> meta: [
		@$metaTag 'robots', 'noindex, nocache'
	]

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

.style-guide
	fluid-space padding, 'l'

.header
	border-bottom 1px solid black

.spacers > *

	// Invert
	background black
	color white

	// Typgraphy
	flex-center()
	font-size 10px
	font-weight bold

	// Seperate from one another
	&:not(:first-child)
		fluid-space margin-top, 'xs'

	// Add sizing
	for size in 'xl' 'l' 'm' 's' 'xs'
		&.{size}
			fluid-space height, size

.swatches
	display flex
	flex-wrap wrap

.swatch
	margin-right spacing-xs
	margin-bottom spacing-xs

	.box
		width 200px
		height 100px
		margin-bottom 10px

		&.primary-color
			background primary-color

		&.primary-color-dark
			background primary-color-dark

		&.secondary-color
			background secondary-color

		&.offwhite
			background offwhite

		&.disabled-fill
			background disabled-fill

		&.ui-border-color
			background white
			border 1px solid ui-border-color

		&.warning-color
			background warning-color

.btn-wrap
	margin-bottom spacing-xs

</style>
