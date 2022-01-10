/**
 * Combine all the helpers into a single exported object
 */
import * as constants from './constants'
import * as dom from './dom'
import * as formatting from './formatting'
import * as routing from './routing'
import * as storage from './storage'
export default {
	...constants,
	...dom,
	...formatting,
	...routing,
	...storage,
}
