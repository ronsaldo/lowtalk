special messages
checkFirstSlotPointerMessage: message receiver: receiver
	| source sourceType targetType |
	self assert: message arguments size <= 1.
	source := receiver.
	sourceType := receiver type withoutReferences.
	(sourceType isDynamicObjectType or: [ sourceType isSpecificDynamicObjectType ]) ifFalse: [ 
		message semanticError: 'Receiver must be an object for message {1}.' format: { message selector printString }.
	].

	message arguments size = 1 ifTrue: [ 
		targetType := self solveTypeExpression: message arguments first.
		targetType isPointerType ifFalse: [ 
			message semanticError: 'Target type of message {1} must be a pointer type.' format: { message selector printString }
		]
	] ifFalse: [
		targetType := compiler dynamicObjectType pointer.
	].
	
	message type: targetType