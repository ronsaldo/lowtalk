special messages
checkPointerDeReferenceMessage: message receiver: receiver
	| receiverType elementType argument |
	receiverType := receiver type withoutReferences.
	message arguments ifNotEmpty: [
		self assert: message arguments size = 1.
		message coercionType: compiler intPointerType.
		argument := message arguments first.
		self visitNode: argument.
		argument type implicitlyConvertedTo: message coercionType at: message arguments first
	].
	
	self assert: (receiverType isPointerType or: [ receiverType isArrayType ]).
	elementType := receiverType isPointerType ifTrue: [ receiverType pointed ] ifFalse: [ receiverType baseType ].
	elementType isVoidType ifTrue: [
		message semanticError: 'Cannot de-reference pointer to void.'
	].

	message type: elementType ref.

	
	