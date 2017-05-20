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
	
	result := LowtalkEvaluator evaluate: node body environment: activationEnvironment.
	resultType := node body type.
	^ resultType convertValue: result toType: node returnType at: node