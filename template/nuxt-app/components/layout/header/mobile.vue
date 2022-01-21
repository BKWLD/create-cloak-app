<!-- Mobile header -->

<template lang='pug'>

detachable-header.layout-header-mobile(:height='height')
	header.max-w-full: .columns.max-w-m

		.left
			nuxt-link(to='/') <%= name %>

		.right
			//- Probably a hamburger

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
import DetachableHeader from 'vue-detachable-header'
import 'vue-detachable-header/index.css'
<%_ if (hasLibrary) { _%>
import dimensions from 'library/assets/vars/dimensions'
<%_ } else { _%>
import dimensions from '~/assets/vars/dimensions'
<%_ } _%>
export default

	components: { DetachableHeader }

	data: -> height: parseInt dimensions['header-h-mobile']

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style src='./header.styl' lang='stylus' scoped></style>
<style lang='stylus' scoped>

.layout-header-mobile
	+tablet-up()
		display none


</style>
