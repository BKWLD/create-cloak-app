# Polyfills that aren't provided by polyfill.io.  I'm not using core-js from
# Babel so I don't double up on polyfills.
import 'regenerator-runtime'
import 'objectFitPolyfill'

# Add Sentry error logging
import './plugins/sentry'

# Global styles
import './styles/app.styl'

# VueX, fetching cart immediately
import { store } from './plugins/vuex'
store.dispatch 'cart/fetchUnlessHydrated'

# Setup GTM instrumentation
import './plugins/gtm'
