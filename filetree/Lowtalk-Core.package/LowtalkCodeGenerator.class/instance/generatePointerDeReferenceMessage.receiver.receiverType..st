messages
generatePointerDeReferenceMessage: message receiver: receiver receiverType: receiverType
	| pointer argument index indexType pointerType |
	pointer := receiver.
	pointerType := receiverType withoutReferences.
	self assert: (pointerType isPointerType or: [pointerType isArrayType]).
	
	pointer := self coerceImplicitly: pointer type: receiverType to: pointerType at: message.
	
	message arguments ifNotEmpty: [ 
		self assert: message arguments size = 1.
		argument := message arguments first.
		index := self visitNode: argument.
		indexType := argument type.
		index := self coerceImplicitly: index type: indexType to: message coercionType at: message.
		
		"One vs zero based indices"
		(#(at: basicAt:) includes: message selector) ifTrue: [
			index := builder sub: index with: (SLVMConstant type: message coercionType ssaType value: 1)
		].
	
		^ pointerType isArrayType
			ifTrue: [ builder getPointer: pointer element: {builder constInt: 0 . index} ]
			ifFalse: [ builder getPointer: pointer element: {index} ]
	].

	^ pointer