expressions
symbolOperatorLiteral
	^ self token: $# asParser , (PPPredicateObjectParser anyOf: '+-/\*~<>=@,%|&?!') plus