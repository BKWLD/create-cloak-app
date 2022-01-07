# Deps
import { makeNuxtUrl } from 'library/services/helpers'

# Redirect to www's 404 page
location.href = makeNuxtUrl '/404' if window.IS_404

# Redirect homepage to www on prod
if process.env.APP_ENV == 'prod' and location.pathname == '/'
then location.href = makeNuxtUrl '/'

# Redirect collection and product pages to www site
if match = location.pathname.match /^\/(collections|products)/
then location.href = makeNuxtUrl location.pathname
