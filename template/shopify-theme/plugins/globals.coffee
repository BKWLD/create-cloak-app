# Core deps
import Vue from 'vue'

# Make a fake smart-link comonent that only remders a tags
import { makeAnchor } from 'nuxt-app/components/globals/smart-link'
import { isNuxtUrl, makeNuxtUrl } from 'library/services/helpers'
Vue.component 'smart-link',
	functional: true
	props: to: String
	render: (create, context) ->
		to = context.props.to
		if !to then return create 'span', context.data, context.children
		if isNuxtUrl to
		then makeAnchor create, context, makeNuxtUrl to
		else makeAnchor create, context
