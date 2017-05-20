as yet unclassified
evaluateInlineBlock: aBlockNode arguments: blockArguments types: blockArgumentTypes at: aNode
	| activationEnvironment argumentDefinition convertedArgument argumentVariable result resultType |
	self solveBlockType: aBlockNode.
	activationEnvironment := LowtalkLocalEnvironment parent: environment.
	
	blockArguments collectWithIndex: [ :arg :index |
		argumentDefinition := aBlockNode arguments at: index.
		convertedArgument := (blockArgumentTypes at: index) convertValue: arg toType: argumentDefinition type at: aNode.
		argumentVariable := LowtalkCompileTimeLocalVariable new
			name: argumentDefinition name;
			value: arg;
			valueType: argumentDefinition type;
			compiler: self compiler;
			yourself.
		activationEnvironment setSymbol: argumentVariable name value: argumentVariable
	].
	
	result := LowtalkEvaluator evaluate: aBlockNode body environment: activationEnvironment.
	resultType := aBlockNode body type.
	^ resultType convertValue: result toType: aBlockNode returnType at: aNode