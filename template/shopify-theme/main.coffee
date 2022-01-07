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

# Add global helpers
import './plugins/helpers'

# Boot misc global JS
import 'focus-visible'
import './plugins/directives'
import './plugins/components'
