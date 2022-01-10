# Core deps
import Vue from 'vue'

# Stub out common directives that probably aren't needed in shopify-theme so
# as to keep the JS size down
Vue.directive 'balance-text', {}
Vue.directive 'unorphan', {}

# Stub out the parse-anchors directive so it doesn't error
Vue.directive 'parse-anchors', {}
