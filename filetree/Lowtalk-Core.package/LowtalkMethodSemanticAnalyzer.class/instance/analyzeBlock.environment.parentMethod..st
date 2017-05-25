as yet unclassified
analyzeBlock: aBlockNode environment: baseEnvironment parentMethod: parentMethod
	| blockEnvironment topEnvironment |
	compiler := baseEnvironment compiler.
	
	self withEnvironment: baseEnvironment do: [ 	
		self solveBlockType: aBlockNode.
	].

	method := LowtalkInterpreterMethod new node: aBlockNode.
	method hasLocalReturns: (aBlockNode hasPragmaNamed: #localReturn).
	
	topEnvironment := baseEnvironment.
	aBlockNode selfType isVoidType ifFalse: [
		topEnvironment := (LowtalkReceiverEnvironment parent: baseEnvironment)
			receiverType: aBlockNode selfType;
			receiver: method.
	].

	blockEnvironment := LowtalkLocalEnvironment parent: topEnvironment.
	method
		environment: blockEnvironment;
		returnType: aBlockNode returnType;
		receiverType: aBlockNode selfType.
	
	self withEnvironment: blockEnvironment do: [ 
		method arguments: (aBlockNode arguments collect: [ :argument | argument accept: self ]).
			
		aBlockNode body accept: self.
	].
	
	^ method