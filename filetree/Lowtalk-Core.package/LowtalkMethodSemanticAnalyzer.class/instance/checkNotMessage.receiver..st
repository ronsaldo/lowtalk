special messages
checkNotMessage: message receiver: receiver
	| receiverValueType |
	receiverValueType := receiver type withoutReferences asValueType.
	
	receiverValueType isBooleanType ifTrue: [ 
		message type: receiverValueType.
		^ self
	].

	^ self checkNormalMessage: message receiver: receiver