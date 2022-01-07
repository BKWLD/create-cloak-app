# Deps
import Vue from 'vue'

<%_ if (shopify) { _%>
# Helper for explicit links
import SmartLink from '~/components/globals/smart-link'
Vue.component 'smart-link', SmartLink

# Shopify Visual
import ShopifyVisual from 'library/components/globals/shopify-visual'
Vue.component 'shopify-visual', ShopifyVisual
<%_ } _%>
