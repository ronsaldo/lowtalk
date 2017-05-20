*Lowtalk-Core
lowtalkValueWithArguments: evaluationArguments types: evaluationArgumentTypes compiler: aLowtalkCompiler at: aNode
	^ self valueWithArguments: (evaluationArguments collectWithIndex: [:arg :index |
		(evaluationArgumentTypes at: index) convertValue: arg toType: aLowtalkCompiler objectType at: aNode
		])