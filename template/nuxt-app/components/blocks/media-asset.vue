<!-- An image or ambient video that may launch a video player  -->

<template lang='pug'>

section.media-asset(:class='classes')

	//- The asset
	<%_ if (cms == 'craft') { _%>
	responsive-craft-visual(
		sizes='100vw'
		:image='block.image'
		:video='block.video')
	<%_ } else if (cms == 'contentful') { _%>
	responsive-contentful-visual(
		sizes='100vw'
		:landscapeImage='block.asset.imageLandscape'
		:portraitImage='block.asset.imagePortrait'
		:landscapeVideo='block.asset.videoLandscape'
		:portraitVideo='block.asset.videoPortrait')
	<%_ } else if (cms == '@nuxt/content') { _%>
	cloak-visual(
		sizes='100vw'
		:image='block.image'
		:video='block.video')
	<%_ } _%>

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
export default

	props: block: Object

	computed:

		# Apply max-width choice
		<%_ if (cms == 'craft' || cms == '@nuxt/content') { _%>
		classes: -> @block.maxWidth
		<%_ } else if (cms == 'contentful') { _%>
		classes: -> @maxWidth

		# Map maxWidth options to classes
		maxWidth: -> switch @block.maxWidth
			when 'Medium' then 'max-w-medium'
			when 'Small' then 'max-w-small'
			when 'Full' then 'max-w-full'
			else 'max-w'
		<%_ } _%>

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

</style>
