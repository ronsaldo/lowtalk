evaluating
lowtalkValueWithArguments: evaluationArguments types: evaluationArgumentTypes compiler: aLowtalkCompiler at: aNode
	| activationEnvironment argumentDefinition convertedArgument argumentVariable result resultType |
	activationEnvironment := LowtalkLocalEnvironment parent: environment parent.

	evaluationArguments collectWithIndex: [ :arg :index |
		argumentDefinition := arguments at: index.
		convertedArgument := (evaluationArgumentTypes at: index) convertValue: arg toType: argumentDefinition type at: aNode.
		argumentVariable := LowtalkCompileTimeLocalVariable new
			name: argumentDefinition name;
			value: arg;
			valueType: argumentDefinition type;
			compiler: aLowtalkCompiler;
			yourself.
		activationEnvironment setSymbol: argumentVariable name value: argumentVariable
	].
	
	result := nil.
	node isBlock ifTrue: [ 
		result := LowtalkEvaluator evaluate: node body environment: activationEnvironment.
		resultType := node body type.
	] ifFalse: [ 
		[
			result := LowtalkEvaluator evaluate: node body environment: activationEnvironment.
			resultType := node body type.
		] on: LowtalkInterpreterReturnException do: [ :returnExc |
			result := returnExc value.
			resultType := returnExc type.
		].
	].

	
	^ returnType isVoidType ifTrue: [nil] ifFalse: [resultType convertValue: result toType: node returnType at: node]