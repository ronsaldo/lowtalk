special messages
visitInlinedBlockArgument: argumentNode
	| variable |
	self solveBlockArgumentType: argumentNode.
	
	variable := LowtalkMethodInlineArgument new
		valueType: argumentNode type;
		name: argumentNode name;
		isConstant: true;
		method: method.
	method addTemporary: variable.
		
	environment setSymbol: variable name value: variable ifPresent: [ 
		argumentNode semanticError: 'Argument variable name {1} is already in use.' format: { variable name printString }
	].

	self flag: 'Remove this hack'.
	argumentNode binding ifNil: [ argumentNode binding: variable ].
	^ argumentNode binding