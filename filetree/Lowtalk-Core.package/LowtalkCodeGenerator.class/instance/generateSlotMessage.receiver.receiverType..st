messages
generateSlotMessage: message receiver: receiver receiverType: receiverType
	| referenceType structureType slot structurePointer |
	structurePointer := receiver.
	referenceType := receiverType.
	structureType := referenceType withoutReferences.
	
	"Make sure we have a pointer to the structure."
	self assert: structureType isStructureType.
	referenceType isReferenceType ifFalse: [
		self assert: referenceType isStructureType.
		structurePointer := allocaBuilder alloca: structureType ssaType.
		self store: receiver in: structurePointer
	].
	
	slot := structureType slotNamed: message selector.
	^ builder getReference: structurePointer element: (builder constInt: slot index).