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

# Shared header & footer
import HeaderPlaceholder from '../components/layout/header-placeholder'
import Footer from 'library/components/layout/footer/footer'
Vue.component 'header-placeholder', HeaderPlaceholder
Vue.component 'layout-footer', Footer

# Mount components
export initComponents = ->

	# Find places to mount components
	# - inline-templates are used for components who use liquid for the template
	# - data-vue-component is for rendering a component in place
	els = document.querySelectorAll('[inline-template], [data-vue-component]')

	# Mount components
	els.forEach ( el ) ->
		return if el.matches '[inline-template] [inline-template]'
		new Vue
			store: window.$store
			delimiters: ['${', '}']
			el: el
