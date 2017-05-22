special messages
checkCastToMessage: message receiver: receiver
	| source sourceType targetType |
	self assert: message arguments size = 1.
	source := receiver.
	sourceType := receiver type withoutReferences.
	targetType := self solveTypeExpression: message arguments first.
	(sourceType canBeExplicitlyConvertedTo: targetType) ifFalse: [
		message semanticError: 'Cannot perform explicit type conversion from {1} to {2}.' format: { sourceType name . targetType name }
	].
	message type: targetType.
