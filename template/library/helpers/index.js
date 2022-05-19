/**
 * Combine all the helpers into a single exported object
 */
export * from './constants'
export * from './dom'
export * from './formatting'
export * from './routing'
export * from './storage'

// Without this, shopify-theme emitted a warning of:
// "export 'default' (imported as 'projectHelpers') was not found
export default {}
