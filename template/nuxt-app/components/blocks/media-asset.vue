<!-- A full width image or ambient video that may launch a video player  -->

<template lang='pug'>

section.media-asset

	//- The asset
	responsive-craft-visual(
		sizes='100vw'
		:image='block.image'
		:video='block.video')

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
export default

	props: block: Object

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

</style>
