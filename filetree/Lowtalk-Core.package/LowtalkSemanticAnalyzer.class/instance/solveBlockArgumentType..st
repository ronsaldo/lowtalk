as yet unclassified
solveBlockArgumentType: argument
	argument type ifNil: [ 
		argument type: (self solveTypeExpression: argument typeExpression).
	]
	
	