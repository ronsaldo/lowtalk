special messages
checkPointerElementAssignmentMessage: message receiver: receiver
	| receiverType elementType index value |
	self assert: message arguments size = 2.
	receiverType := receiver type withoutReferences.
	message coercionType: compiler intPointerType.

	index := message arguments first.
	value := message arguments second.
	
	self visitNode: index.
	self visitNode: value.
	
	index type implicitlyConvertedTo: message coercionType at: index.
	
	self assert: (receiverType isPointerType or: [ receiverType isArrayType ]).
	elementType := receiverType isPointerType ifTrue: [ receiverType pointed ] ifFalse: [ receiverType baseType ].
	value type implicitlyConvertedTo: message coercionType at: elementType.
	message type: elementType ref.
