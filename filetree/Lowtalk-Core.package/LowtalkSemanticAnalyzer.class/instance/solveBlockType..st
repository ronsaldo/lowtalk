as yet unclassified
solveBlockType: aBlockNode
	aBlockNode type ifNotNil: [ ^ self ].
	aBlockNode arguments do: [ :arg | self solveBlockArgumentType: arg ].
	aBlockNode returnType: (self solveTypeExpression: aBlockNode returnTypeExpression).
	
	aBlockNode type: ((LowtalkFunctionType target: self compiler compilationTarget)
			arguments: (aBlockNode arguments collect: #type);
			returnType: aBlockNode returnType;
			yourself) block.
