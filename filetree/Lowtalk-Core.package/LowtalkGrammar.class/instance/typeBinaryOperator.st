type expression
typeBinaryOperator
	^ (self token: (PPPredicateObjectParser anyOf: '+-/\*~<>=@,%|&?!') plus) >=> [ :stream :continuation |
		| result memento |
		memento := stream remember.
		result := continuation value.
		(result isPetitFailure not and: [ result inputValue = #> ]) ifTrue: [
			stream restore: memento.
			PPFailure message: 'Invalid type binary operator.' context: stream
		] ifFalse: [
			result
		]
	]