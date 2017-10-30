messages
generateSlotMessage: message receiver: receiver receiverType: receiverType
	| referenceType objectType slot objectPointer |
	objectPointer := receiver.
	referenceType := receiverType.
	objectType := referenceType withoutReferences.
	
	"Make sure we have a pointer to the pointer instead of a value."
	self assert: (objectType isStructureType or: [objectType isObjectSlots]).
	(objectType isStructureType and: [referenceType isReferenceType not]) ifTrue: [
		self assert: referenceType isStructureType.
		objectPointer := allocaBuilder alloca: objectType ssaType.
		self store: receiver in: objectPointer
	].
	
	slot := objectType slotNamed: message selector.
	^ slot emitSSASlotReferenceOf: objectPointer builder: builder at: message