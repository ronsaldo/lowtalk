code generation
emitSSASlotReferenceOf: objectValue builder: builder at: node
	| slotContainerValue |
	slotContainerValue := objectValue.
	(ssaReceiverCastType isNotNil and: [ objectValue type isDynamicObjectType ]) ifTrue: [ 
		self assert: ssaReceiverCastType isPointerType.
		"Get a pointer to the first slot."
		slotContainerValue := (builder getReference: slotContainerValue element: (SLVMConstantValue int: 0)).
		
		"Cast the pointer of the first slot."
		slotContainerValue := builder bitCast: slotContainerValue target: ssaReceiverCastType
	].

	^ builder getReference: slotContainerValue element: (builder constInt: index)
