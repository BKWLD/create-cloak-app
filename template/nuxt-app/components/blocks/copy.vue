<!-- Copy block -->

<template lang='pug'>

section.copy.max-w-small(:class='classes')

	<%_ if (cms == 'craft') { _%>
	wysiwyg(
		:html='block.body'
		:balance-text='block.balanceText'
		:unorphan='block.unorphan')
	<%_ } else if (cms == 'contentful') { _%>
	rich-text(
		:doc='block.body'
		:balance-text='block.balanceText'
		:unorphan='block.unorphan')
	<%_ } _%>

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
export default

	props: block: Object

	computed:

		# Root classes
		classes: ->
			'text-' + @block.textAlignment.toLowerCase() if @block.textAlignment

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

// Center contents
.text-center
	text-align center
	>>> .vv-visual
		margin-h auto

// Right align contents
.text-right
	text-align right
	>>> .vv-visual
		margin-left auto

</style>
