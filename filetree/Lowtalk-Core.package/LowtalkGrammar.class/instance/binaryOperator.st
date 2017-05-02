tokens
binaryOperator
	^ self token: (PPPredicateObjectParser anyOf: '+-/\*~<>=@,%|&?!') plus