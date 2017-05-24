tokens
identifier
	^ (self token: identifierStart ,  identifierInner star , $: asParser not) >=> [ :stream :continuation |
		| result memento |
		memento := stream remember.
		result := continuation value.
		(result isPetitFailure not and: [ Keywords includes: result inputValue ]) ifTrue: [
			stream restore: memento.
			PPFailure message: 'expected an identifier, not a keyword.' context: stream
		] ifFalse: [
			result
		]
	]