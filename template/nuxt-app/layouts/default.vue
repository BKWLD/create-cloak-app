<!-- General layout -->

<template lang='pug'>

.default-layout
	a.skip-content(href='#main') Skip to main content

	//- Header stuff
	layout-header-desktop
	layout-header-mobile

	//- Page content
	main#main
		nuxt.page
		layout-footer

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
export default
	name: 'DefaultLayout'

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

// Prevent mega-wide pages
.default-layout
	max-width max-w-full
	margin-h auto
	width 100%

// On short pages, pin the footer to the bottom of the page
main
	min-height 100vh
	display flex
	flex-direction column
.page
	flex-grow 1

.skip-content
	position absolute
	left -1000px
	z-index header-z // stacked below nav but above page content

	// adjust spacing when header changes
	+when-desktop-header()
		top (header-h + spacing-s)
	+when-mobile-header()
		top (header-h-mobile + spacing-s-min)

	&:focus
		fluid left, gutter, gutter-mobile
		outline none

</style>
