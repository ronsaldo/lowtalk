accessing
messages: anObject
	messages := anObject.
	messages do: [ :message |
		message isCascaded: true
	]