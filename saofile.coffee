module.exports =

	description: 'Testing'

	prompts: -> [
		{
			name: 'name'
			message: 'What is the name of the new project'
			default: this.outFolder
		}
	]

	actions: [
		{
			type: 'add'
			files: '**'
		}
	]
