special messages
checkPointerDeReferenceMessage: message receiver: receiver
	| receiverType elementType argument |
	receiverType := receiver type withoutReferences.
	message arguments ifNotEmpty: [
		self assert: message arguments size = 1.
		message coercionType: compiler intPointerType.
		argument := message arguments first.
		argument accept: self.
		argument type implicitlyConvertedTo: message coercionType at: message arguments first
	].
	
	self assert: (receiverType isPointerType or: [ receiverType isArray ]).
	elementType := receiverType isPointerType ifTrue: [ receiverType pointed ] ifFalse: [ receiverType elementType ].
	message type: elementType ref.

	
	