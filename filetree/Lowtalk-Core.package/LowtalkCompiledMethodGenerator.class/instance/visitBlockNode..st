visiting
visitBlockNode: aBlockNode
	| blockMethod argumentNames tempNames copiedNames |
	aBlockNode arguments size > 15 ifTrue: [self backendError: 'Too many arguments' forNode: aBlockNode ].
	
	blockMethod := aBlockNode definition.
	blockMethod hasLocalReturns ifTrue: [ 
		self halt.
	].

	blockMethod arguments do: [ :arg |
		arg compiledMethodVariable: (self convertTemporaryName: arg name).
	].

	blockMethod temporaries do: [ :temp |
		temp compiledMethodVariable: (self convertTemporaryName: temp name).
	].

	argumentNames := (blockMethod arguments collect: #compiledMethodVariable) asArray.
	tempNames := (blockMethod temporaries collect: #compiledMethodVariable) asArray.
	copiedNames := (blockMethod outerClosureVariables collect: #compiledMethodVariable) asArray..

	irBuilder
			pushClosureCopyCopiedValues: copiedNames
			args: argumentNames
			jumpTo:  #block.

	irBuilder addTemps: tempNames.
	blockMethod temporaries do: [ :temp |
		self initializeTemporary: temp
	].
	
	self withMethod: blockMethod do: [
		self visitNode: aBlockNode body.
	].
	
	blockMethod returnType isVoidType ifTrue: [ 
		irBuilder pushLiteral: nil.
	] ifFalse: [
		self coerceImplicitlyFrom: aBlockNode body type to: blockMethod returnType at: aBlockNode
	].

	irBuilder blockReturnTop.
	irBuilder jumpAheadTarget: #block;
		pushLiteral: blockMethod;
		send: #asLowtalkBlockClosureFor:
