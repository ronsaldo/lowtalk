tokens
binaryOperator
	^ self operator: (PPPredicateObjectParser anyOf: '+-/\*~<>=@,%|&?!') plus