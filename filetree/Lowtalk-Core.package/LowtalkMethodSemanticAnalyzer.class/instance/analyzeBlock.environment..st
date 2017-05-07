as yet unclassified
analyzeBlock: aBlockNode environment: baseEnvironment
	| blockEnvironment |
	compiler := baseEnvironment compiler.
	
	self solveBlockType: aBlockNode.

	blockEnvironment := LowtalkLocalEnvironment parent: baseEnvironment.
	method := LowtalkInterpreterMethod new node: aBlockNode;
		environment: blockEnvironment;
		returnType: aBlockNode returnType;
		receiverType: compiler voidType.
	
	self withEnvironment: blockEnvironment do: [ 
		method arguments: (aBlockNode arguments collect: [ :argument | argument accept: self ]).
			
		aBlockNode body accept: self.
	].
	
	^ method