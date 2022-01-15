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


# Modal
import Modal from '@bkwld/vue-modal'
Vue.component 'modal', Modal
import '@bkwld/vue-modal/index.css'

# Embed wysiwyg
import Embed from '@bkwld/vue-embed'
Vue.component 'vue-embed', Embed

# Hamburger
import Hamburger from 'vue-hamburger'
Vue.component 'hamburger', Hamburger
import 'vue-hamburger/index.css'
