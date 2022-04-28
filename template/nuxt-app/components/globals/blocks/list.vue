<!-- Renders all blocks -->

<template lang='pug'>

.block-list(v-if='createdBlocks.length')

	//- Render component
	blocks-commons(
		v-for='(block, index) in createdBlocks'
		<%_ if (cms == 'craft') { _%>
		:key='block.id || index'
		<%_ } else { _%>
		:key='index'
		<%_ } _%>
		:index='index + indexOffset')
		component(:is='block.componentName' :block='block')

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
import Vue from 'vue'

# Mapping of Craft _typename to component
export mapping = <% if (!cms) { %>{}<% } %>
	<%_ if (cms == 'craft') { _%>
	blocks_copy_BlockType: 'cloak-copy-craft-block'
	blocks_mediaAsset_BlockType: 'cloak-visual-craft-block'
	blocks_simpleMarquee_BlockType: 'blocks-simple-marquee'
	blocks_spacer_BlockType: 'blocks-spacer'
	blocks_wrapper_BlockType: 'blocks-wrapper'
	<%_ } else if (cms == 'contentful') { _%>
	BlockCopy: 'cloak-copy-contentful-block'
	BlockMediaAsset: 'cloak-visual-contentful-block'
	BlockSpacer: 'blocks-spacer'
	BlockWrapper: 'blocks-wrapper'
	<%_ } else if (cms == '@nuxt/content') { _%>
	copy: 'cloak-copy-craft-block'
	simpleMarquee: 'blocks-simple-marquee'
	spacer: 'blocks-spacer'
	visual: 'cloak-visual-craft-block'
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
