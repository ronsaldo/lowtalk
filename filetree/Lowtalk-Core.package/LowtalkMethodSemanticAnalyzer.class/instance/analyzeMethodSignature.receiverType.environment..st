as yet unclassified
analyzeMethodSignature: methodNode receiverType: receiverType environment: baseEnvironment
	| arguments returnType argumentTypes callingConvention functionType |
	compiler := baseEnvironment compiler.

	self withEnvironment: baseEnvironment do: [
		"Solve the arguments first."
		arguments := methodNode arguments collect: [ :arg |
			LowtalkMethodArgument new
				definitionNode: arg;
				valueType: (self solveTypeExpression: arg typeExpression);
				name: arg name;
				isConstant: true.
		].

		"Solve the return type."
		returnType := self solveTypeExpression: methodNode returnTypeExpression defaultType: (receiverType asDefaultReturnTypeWith: compiler).
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
	^ functionType