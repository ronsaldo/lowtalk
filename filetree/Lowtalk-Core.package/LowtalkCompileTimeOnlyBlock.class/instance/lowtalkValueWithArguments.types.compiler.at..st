evaluating
lowtalkValueWithArguments: evaluationArguments types: evaluationArgumentTypes compiler: aLowtalkCompiler at: aNode
	| activationEnvironment argumentVariable |
	evaluationArguments size ~= node arguments size ifTrue: [
		aNode semanticError: 'Expected {1} arguments instead of {2} arguments.' format: { evaluationArguments size . node arguments size }
	].

	activationEnvironment := LowtalkLocalEnvironment parent: environment.
	node arguments doWithIndex: [ :argumentDefinition :index |
		argumentVariable := LowtalkCompileTimeArgumentLocalVariable new
			name: argumentDefinition name;
			value: (evaluationArguments at: index);
			valueType: (evaluationArgumentTypes at: index);
			compiler: self compiler;
			yourself.
		activationEnvironment setSymbol: argumentVariable name value: argumentVariable
	].
	^ LowtalkEvaluator evaluateValue: node body environment: activationEnvironment.