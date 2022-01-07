# Core deps
import Vue from 'vue'

# Add shared global components
import balanceText from 'vue-balance-text'
Vue.directive 'balance-text', balanceText

# Stub out the parse-anchors directive so it doesn't error
Vue.directive 'parse-anchors', {}
