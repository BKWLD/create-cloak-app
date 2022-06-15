// Fire postMessage as part of live preview
// https://github.com/craftcms/cms/issues/5359
Garnish.on(Craft.Preview, 'beforeUpdateIframe', function(event) {
	if (event.refresh) return
	event.target.$iframe[0].contentWindow.postMessage('preview:change', '*')
})
