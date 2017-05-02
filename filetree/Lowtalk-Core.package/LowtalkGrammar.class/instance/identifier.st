tokens
identifier
	^ (self token: identifierStart ,  identifierInner star , $: asParser not) >=> [ :stream :continuation |
		| result |
		result := continuation value.
		(result isPetitFailure not and: [ Keywords includes: result inputValue ]) ifTrue: [
			PPFailure message: 'expected an identifier, not a keyword.' context: stream
		] ifFalse: [
			result
		]
	]