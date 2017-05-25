as yet unclassified
solveBlockType: aBlockNode
	| callingConvention argumentTypes |
	aBlockNode type ifNotNil: [ ^ self ].
	aBlockNode arguments do: [ :arg | self solveBlockArgumentType: arg ].
	aBlockNode returnType: (self solveTypeExpression: aBlockNode returnTypeExpression).
	aBlockNode selfType: (self solveTypeExpression: aBlockNode selfTypeExpression defaultType: compiler voidType).

	callingConvention := compiler defaultCallingConvention.
	aBlockNode pragmasDo: [ :pragma |
		(CallingConventionNames includes: pragma selector) ifTrue: [
			callingConvention := pragma selector
		]
	].

	argumentTypes := aBlockNode arguments collect: #type.
	aBlockNode selfType isVoidType ifFalse: [ 
		argumentTypes := { aBlockNode selfType } , argumentTypes
	].

	aBlockNode type: ((LowtalkFunctionType target: self compiler compilationTarget)
			arguments: argumentTypes;
			returnType: aBlockNode returnType;
			callingConvention: callingConvention;
			yourself) block.
