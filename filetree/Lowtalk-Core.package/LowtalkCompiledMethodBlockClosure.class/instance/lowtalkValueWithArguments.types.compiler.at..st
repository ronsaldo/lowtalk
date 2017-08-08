evaluating
lowtalkValueWithArguments: evaluationArguments types: evaluationArgumentTypes compiler: aLowtalkCompiler at: aNode

	| convertedArguments argumentType expectedArgumentType |
	convertedArguments := evaluationArguments collectWithIndex: [ :argument :index |
		argumentType := evaluationArgumentTypes at: index.
		expectedArgumentType := (definition arguments at: index) type.
		argumentType convertValue: argument toType: expectedArgumentType at: aNode
	].
	^ closure valueWithArguments: convertedArguments