<!-- General layout -->

<template lang='pug'>

.default-layout

	//- Header stuff
	layout-header-desktop
	layout-header-mobile

	//- Page content
	main
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

// On short pages, pin the footer to the bottom of the page
main
	min-height 100vh
	display flex
	flex-direction column
.page
	flex-grow 1

// Prevent mega-wide pages
.default-layout
	max-width max-w-full
	margin-h auto
	width 100%
	overflow hidden

</style>
