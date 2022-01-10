import Vue from 'vue'

# Get helpers
import * as cloakHelpers from '@bkwld/cloak/services/helpers'
import * as projectHelpers from 'library/helpers'

# Install helpers
helpers = { ...cloakHelpers, ...projectHelpers }
Vue.prototype['$' + key] = func for key, func of helpers
