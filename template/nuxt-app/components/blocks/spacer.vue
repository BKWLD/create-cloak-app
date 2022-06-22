<!-- Spacer block -->

<template lang='pug'>

section.spacer(:class='classes')

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
export default

	props: block: Object

	<%_ if (cms == 'craft' || cms == '@nuxt/content') { _%>
	computed:

		# Root classes
		classes: -> "height-#{@block.height}"
		<%_ } else if (cms == 'contentful') { _%>
		classes: -> "height-#{@heightSlug}"

		# Map heights to shorthands
		heightSlug: -> switch @block.height
			when 'Small' then 's'
			when 'Medium' then 'm'
			when 'Large' then 'l'
			when 'Extra Large' then 'xl'
			else throw "Unknown height #{@block.height}"
	<%_ } _%>

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

.spacer
	&.height-s
		fluid-space height, 's'
	&.height-m
		fluid-space height, 'm'
	&.height-l
		fluid-space height, 'l'
	&.height-xl
		fluid-space height, 'xl'

</style>
