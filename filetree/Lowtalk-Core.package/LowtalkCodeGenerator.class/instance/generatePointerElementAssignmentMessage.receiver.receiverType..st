messages
generatePointerElementAssignmentMessage: message receiver: receiver receiverType: receiverType
	| pointer index pointerType indexNode elementPointer elementType valueNode value |
	pointer := receiver.
	pointerType := receiverType withoutReferences.
	self assert: (pointerType isPointerType or: [pointerType isArrayType]).
	
	pointer := self coerceImplicitly: pointer type: receiverType to: pointerType at: message.
	self assert: message arguments size = 2.

	indexNode := message arguments first.
	index := self visitNode: indexNode.
	index := self coerceImplicitly: index type: indexNode type to: message coercionType at: message.
		
	"One vs zero based indices"
	(#(at:put: basicAt:put:) includes: message selector) ifTrue: [
		index := builder sub: index with: (SLVMConstant type: message coercionType ssaType value: 1)
	].

	elementPointer := pointerType isArrayType
			ifTrue: [ builder getPointer: pointer element: {builder constInt: 0 . index} ]
			ifFalse: [ builder getPointer: pointer element: {index} ].
	
	elementType := pointerType isArrayType ifTrue: [ pointerType baseType ] ifFalse: [ pointerType pointed ].
	
	valueNode := message arguments second.
	value := self visitNode: valueNode.
	value := self coerceImplicitly: value type: valueNode type to: elementType at: valueNode.

	builder store: value in: elementPointer.
	^ elementPointer