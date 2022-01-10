<!-- Inline template for the header  -->

<script lang='coffee'>
import HeaderDesktop from 'library/components/layout/header/desktop'
import HeaderMobile from 'library/components/layout/header/mobile'
export default

	components: {
		HeaderDesktop
		HeaderMobile
	}

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus'>

.header-placeholder

	// Affix like affixing-header
	position fixed
	width 100%
	z-index header-z
	top 0
	left 0

	// Center the text
	background rgba(black, 0.5)
	color white
	flex-center()

	// Style header
	+tablet-up()
		height header-h
	+tablet-down()
		height header-h-mobile


</style>
