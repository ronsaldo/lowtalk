special messages
visitInlinedBlock: node
	| blockEnvironment argumentTypes actualReturnType functionType |
	node isBlockNode ifFalse: [ ^ node accept: self ].
	node inlined: true.
	
	blockEnvironment := LowtalkEnvironment parent: environment.
	node selfType: (self solveTypeExpression: node selfTypeExpression defaultType: compiler voidType).
	self withEnvironment: blockEnvironment do: [ 
		argumentTypes := node arguments collect: [ :arg | (self visitInlinedBlockArgument: arg) type ].
		node body accept: self.
	].

	actualReturnType := node body type.
	node returnTypeExpression ifNil: [
		actualReturnType isVoidType ifTrue: [ actualReturnType := compiler nilType ].
		node returnType: actualReturnType.
	] ifNotNil: [
		node returnType: (self solveTypeExpression: node returnTypeExpression).
		actualReturnType implicitlyConvertedTo: node returnType at: node.
	].

	functionType := (LowtalkFunctionType target: compiler compilationTarget) arguments: argumentTypes; returnType: node returnType.
	node type: functionType block.