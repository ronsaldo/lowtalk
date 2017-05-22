messages
generateStructureNewMessage: message receiver: receiver receiverType: receiverType
	| structureType structureVariable slotPointer |
	structureType := receiverType withoutReferences.
	self assert: structureType isMetaType.
	structureType := structureType instanceType.
	self assert: structureType isStructureType.
	
	structureVariable := allocaBuilder alloca: structureType ssaType.
	
	structureType fields doWithIndex: [ :field :index |
		slotPointer := builder getReference: structureVariable element: (builder constInt: index - 1).
		builder store: (field defaultSSAValueWith: builder) in: slotPointer
	].

	^ message type isReferenceType ifTrue: [ structureVariable ] ifFalse: [ builder load: structureVariable ]
	