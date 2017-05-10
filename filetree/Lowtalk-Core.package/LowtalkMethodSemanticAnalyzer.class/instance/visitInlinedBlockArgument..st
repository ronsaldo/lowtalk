special messages
visitInlinedBlockArgument: argumentNode
	| variable |
	self solveBlockArgumentType: argumentNode.
	
	variable := LowtalkMethodInlineArgument new
		valueType: argumentNode type;
		name: argumentNode name;
		isConstant: true.
	environment setSymbol: variable name value: variable ifPresent: [ 
		argumentNode semanticError: 'Argument variable name {1} is already in use.' format: { variable name printString }
	].

	argumentNode binding: variable.
	^ variable