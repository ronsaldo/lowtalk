overrides
atOffsetPut: selector receiver: receiver arguments: arguments inSuperclass: isInSuperclass node: aNode compiler: aCompiler
	| index value |
	self assert: arguments size = 2.
	index := arguments first value + 1.
	value := arguments second value.
	^ receiver lowtalkPerform: #at:put: withLazyArguments: { index . value } inSuperclass: isInSuperclass node: aNode compiler: aCompiler