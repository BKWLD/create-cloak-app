###
Create VueX store and initialize cart
###
import Vue from 'vue'
import Vuex from 'vuex'
import * as cart from 'library/store/cart'
import * as globals from 'library/store/globals'

# Create VueX store
Vue.use Vuex
store = new Vuex.Store modules:
	cart: { ...cart, namespaced: true }
	globals: { ...globals, namespaced: true }

# Add plugins
import { lazyHydrateCart } from 'library/services/cart/hydrate-cart'
lazyHydrateCart store

# Load global data automatically
store.dispatch 'globals/fetch'

# Expose for global code to use
window.$store = store
export store = store
