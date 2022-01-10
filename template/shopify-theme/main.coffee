# Conditionally redirect to www site
import './plugins/redirects'

# Polyfills that aren't provided by polyfill.io.  I'm not using core-js from
# Babel so I don't double up on polyfills.
import 'regenerator-runtime'
import 'objectFitPolyfill'

# Add Sentry error logging
import './plugins/sentry'

# Global styles
import './styles/app.styl'

# VueX
import './plugins/vuex'

# Setup GTM instrumentation
import './plugins/gtm'

# Add global helpers
import './plugins/helpers'

# Boot misc global JS
import 'focus-visible'
import './plugins/directives'
import { initComponents } from './plugins/components'
initComponents()
