as yet unclassified
solveBlockType: aBlockNode
	| callingConvention |
	aBlockNode type ifNotNil: [ ^ self ].
	aBlockNode arguments do: [ :arg | self solveBlockArgumentType: arg ].
	aBlockNode returnType: (self solveTypeExpression: aBlockNode returnTypeExpression).

	callingConvention := compiler defaultCallingConvention.
	aBlockNode pragmasDo: [ :pragma |
		(CallingConventionNames includes: pragma selector) ifTrue: [
			callingConvention := pragma selector
		]
	].

	aBlockNode type: ((LowtalkFunctionType target: self compiler compilationTarget)
			arguments: (aBlockNode arguments collect: #type);
			returnType: aBlockNode returnType;
			callingConvention: callingConvention;
			yourself) block.
