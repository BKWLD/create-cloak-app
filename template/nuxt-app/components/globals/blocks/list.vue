<!-- Renders all blocks -->

<template lang='pug'>

.block-list

	//- Render component
	blocks-commons(
		v-for='(block, index) in createdBlocks'
		<%_ if (cms == 'craft') { _%>
		:key='block.id || index'
		<%_ } else if (cms == 'contentful') { _%>
		:key='id'
		<%_ } _%>
		:index='index + indexOffset')
		component(:is='block.componentName' :block='block')

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
import Vue from 'vue'

# Mapping of Craft _typename to component
export mapping =
	<%_ if (cms == 'craft') { _%>
	blocks_copy_BlockType: 'blocks-copy'
	blocks_mediaAsset_BlockType: 'blocks-media-asset'
	blocks_simpleMarquee_BlockType: 'blocks-simple-marquee'
	blocks_spacer_BlockType: 'blocks-spacer'
	blocks_wrapper_BlockType: 'blocks-wrapper'
	<%_ } else if (cms == 'contentful') { _%>
	BlockCopy: 'blocks-copy'
	BlockMediaAsset: 'blocks-media-asset'
	BlockSpacer: 'blocks-spacer'
	BlockWrapper: 'blocks-wrapper'
	<%_ } _%>

# Hard import marquee components so they don't get chunked
import '~/components/blocks/simple-marquee'

# Component def for this block
export default
	name: 'BlockList'

	props:
		blocks: Array

		# Used by Wrapper so the children don't get an offset of zero and disable
		# lazly loading. Note, this isn't perfect because any blocks after the
		# wrapper block won't currently be offset by the preceeding wrapper's
		# children count, but it works for our simple need of enabling lazy loading.
		indexOffset:
			type: Number
			default: 0

	computed:

		# Filter the blocks to those that have been defined.  To fix errors in dev
		# environments after content model is created but commits with the new
		# block component have not been pulled down.
		createdBlocks: ->
			(@blocks || [])
			.map (block) -> {
					...block
					componentName: mapping[block.__typename]
				}
			.filter (block) -> !!block.componentName

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus'>

</style>
