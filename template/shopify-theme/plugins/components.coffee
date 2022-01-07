# Core deps
import Vue from 'vue'

# Craft visual
import CraftVisual from '@bkwld/cloak/components/craft-visual'
Vue.component 'craft-visual', CraftVisual

# Shopify visual
import ShopifyVisual from 'library/components/globals/shopify-visual'
Vue.component 'shopify-visual', ShopifyVisual

# Make a fake smart-link comonent that only remders <a> tags
import { makeAnchor } from 'nuxt-app/components/globals/smart-link'
import { isNuxtUrl, makeNuxtUrl } from 'library/helpers/routing'
Vue.component 'smart-link',
	functional: true
	props: to: String
	render: (create, context) ->
		to = context.props.to
		if !to then return create 'span', context.data, context.children
		if isNuxtUrl to
		then makeAnchor create, context, makeNuxtUrl to
		else makeAnchor create, context
