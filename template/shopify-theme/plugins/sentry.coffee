import Vue from 'vue'
import * as Sentry from '@sentry/browser'
import { Vue as VueIntegration } from '@sentry/integrations'

# Instantiate Sentry unless on a dev environment
unless process.env.APP_ENV == 'dev' then Sentry.init
	dsn: process.env.SENTRY_DSN
	environment: process.env.APP_ENV
	integrations: [ new VueIntegration({
		Vue
		attachProps: true
		logErrors: true
	})]
