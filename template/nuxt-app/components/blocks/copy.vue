<!-- Copy block -->

<template lang='pug'>

section.copy.max-w-small
	wysiwyg(
		:balance-text='block.balanceText'
		:unorphan='block.unorphan'
		:html='block.body')

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
export default

	props: block: Object

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>


</style>
