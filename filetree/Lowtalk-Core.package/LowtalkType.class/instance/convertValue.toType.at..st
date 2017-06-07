converting
convertValue: value toType: targetType at: sendingNode
	self = targetType ifTrue: [ ^ value ].
	(self canBeExplicitlyConvertedTo: targetType) ifFalse: [
		sendingNode semanticError: 'Cannot perform implicit conversion from "{1}" to "{2}"' format: { self name . targetType name }
	].
	
	targetType isDynamicObjectType ifTrue: [ ^ value lowtalkConvertToObjectAt: sendingNode ].
	targetType isIntegerType ifTrue: [ ^ targetType truncateLiteralValue: value at: sendingNode ].

	self error: ('Unimplemented type conversion from "{1}" to "{2}"' format: {self name . targetType name })