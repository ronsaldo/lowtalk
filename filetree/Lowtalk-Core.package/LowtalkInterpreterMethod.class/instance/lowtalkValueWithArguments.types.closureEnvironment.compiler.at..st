evaluating
lowtalkValueWithArguments: evaluationArguments types: evaluationArgumentTypes closureEnvironment: closureEnvironment compiler: aLowtalkCompiler at: aNode
	self hasLazySelector ifFalse: [
		(self bytecodeMethodWithEnvironment: closureEnvironment compiler: aLowtalkCompiler) ifNotNil: [ :compiledMethod |
			^ self evaluateCompiledMethod: compiledMethod withArguments: evaluationArguments types: evaluationArgumentTypes compiler: aLowtalkCompiler at: aNode
		]
	].

	^ self interpretASTWithArguments: evaluationArguments types: evaluationArgumentTypes closureEnvironment: closureEnvironment compiler: aLowtalkCompiler at: aNode