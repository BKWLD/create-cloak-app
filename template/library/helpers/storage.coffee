###
Helpers related to persistent storage like cookies or local storage
###
import Cookies from 'js-cookie'
import { currentApexDomain } from './routing'

# Helpers for interacting with cookies that get shared across domains
export cookie = new class SharedCookie

	# Make the env-specifc key suffic
	constructor: ->
		@suffix = if (env = process.env.APP_ENV) == 'prod'
		then '' else "-#{env}"

	# Set a cookie that can be shared across subdomains
	set: (key, value, options = {}) ->
		Cookies.set key + @suffix, value, {

			# Don't try to share between domains when on a deploy preview
			domain: do ->
				if (apexDomain = currentApexDomain()) == 'netlify.app'
				then undefined else apexDomain

			# Don't expect SSL locally
			secure: location.hostname not in ['localhost']

			# Don't send to any 3rd party sites
			sameSite: 'strict'

			# Allow overriding
			...options
		}

	# Get a cookie
	get: (key) -> Cookies.get key + @suffix

	# Remove a cookie
	remove: (key) -> Cookies.remove key + @suffix, domain: currentApexDomain()
