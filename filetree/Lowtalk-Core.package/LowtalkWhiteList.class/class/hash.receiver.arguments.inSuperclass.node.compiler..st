overrides
hash: selector receiver: receiver arguments: arguments inSuperclass: isInSuperclass node: aNode compiler: aCompiler
	| targetType receiverType |
	self assert: arguments size = 0.
	receiver isString ifTrue: [
		 ^ String stringHash: receiver initialHash: 0
	].

	^ receiver hash