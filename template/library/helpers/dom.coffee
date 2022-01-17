###
Helpers related to manipulating the DOM
###
import Vue from 'vue'
import memoize from 'lodash/memoize'
import { wait } from '@bkwld/cloak/services/helpers'

# Mount a component within an element
export mountComponent = (
	component,    # A Vue component object or reference
	options = {}, # Component intialization options
	{             # Mounting options
		el,         # Mount inside of this element, defaults to document.body
		prepend,    # Boolean, prepend instad of append
	} = {}
) -> new Promise (resolve) ->

	# Set default options
	el = document.body unless el
	options.parent = window.$nuxt?.$root unless options.parent

	# Mounts the component
	mount = ->
		vm = new (Vue.extend component)(options)
		vm.$mount()
		el[if prepend then 'prepend' else 'appendChild'](vm.$el)
		resolve vm

	# Wait until Nuxt is booted to mount
	if window.$nuxt then mount() else wait 50, mount

# Create a script tag and watch for it to load
export loadScript = memoize (src, {
	defer = false
	async = false
} = {}) -> return new Promise (resolve, reject) ->
	script = document.createElement('script')
	script.onload = resolve
	script.onerror = reject
	script.src = src
	script.defer = true if defer
	script.async = true if async
	document.head.appendChild script

