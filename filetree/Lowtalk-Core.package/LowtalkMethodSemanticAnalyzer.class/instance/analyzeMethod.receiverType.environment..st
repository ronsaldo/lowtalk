as yet unclassified
analyzeMethod: methodNode receiverType: receiverType environment: baseEnvironment
	| methodEnvironment topEnvironment arguments returnType argumentTypes callingConvention functionType |
	compiler := baseEnvironment compiler.
	
	self withEnvironment: baseEnvironment do: [
		returnType := self solveTypeExpression: methodNode returnTypeExpression defaultType: (receiverType asDefaultReturnTypeWith: compiler).
		arguments := methodNode arguments collect: [ :arg |
			LowtalkMethodArgument new
				definitionNode: arg;
				valueType: (self solveTypeExpression: arg typeExpression);
				name: arg name;
				isConstant: true.
		]
	].

	argumentTypes := arguments collect: #valueType.
	receiverType isVoidType ifFalse: [ 
		argumentTypes := { receiverType } , argumentTypes
	].

	callingConvention := compiler defaultCallingConvention.
	functionType := (LowtalkFunctionType target: self compiler compilationTarget)
			arguments: argumentTypes;
			returnType: returnType;
			callingConvention: callingConvention;
			yourself.

	method := LowtalkInterpreterMethod new node: methodNode.
	method
		type: functionType;
		hasLocalReturns: true.
	
	topEnvironment := (LowtalkReceiverEnvironment parent: baseEnvironment)
		receiverType: receiverType;
		receiver: method.

	methodEnvironment := LowtalkLocalEnvironment parent: topEnvironment.
	method
		environment: methodEnvironment;
		returnType: returnType;
		receiverType: receiverType;
		arguments: arguments;
		selector: methodNode selector.
	
	self withEnvironment: methodEnvironment do: [ 
		arguments do: [ :arg |
			arg method: method.
			environment setSymbol: arg name value: arg ifPresent: [ 
				arg definitionNode semanticError: 'Argument variable name {1} is already in use.' format: { arg name printString }
			].
		].
		
		self visitNode: methodNode body
	].
	
	^ method