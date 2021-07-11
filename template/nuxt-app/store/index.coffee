export actions =

	# Fetch global data
	nuxtServerInit: ({ dispatch }) ->
		await dispatch 'globals/fetch'
