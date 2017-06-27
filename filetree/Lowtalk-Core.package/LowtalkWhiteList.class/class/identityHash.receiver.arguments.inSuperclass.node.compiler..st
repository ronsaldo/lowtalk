overrides
identityHash: selector receiver: receiver arguments: arguments inSuperclass: isInSuperclass node: aNode compiler: aCompiler
	self assert: arguments size = 0.
	receiver isSymbol ifTrue: [
		^ aCompiler objectModel truncateIdentityHash: (self hash: selector receiver: receiver arguments: arguments inSuperclass: isInSuperclass node: aNode compiler: aCompiler)
	].

	^ aCompiler objectModel truncateIdentityHash: receiver identityHash