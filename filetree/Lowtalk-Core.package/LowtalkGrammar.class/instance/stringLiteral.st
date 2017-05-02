expressions
stringLiteral
	^ self token: $' asParser , ($' asParser negate | ($' asParser , $' asParser)) star , $' asParser