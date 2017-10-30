messages
generateSetSlotMessage: message receiver: receiver receiverType: receiverType
	| referenceType objectType slot objectPointer slotPointer newValue newValueType |
	self assert: message arguments size = 1.
	objectPointer := receiver.
	referenceType := receiverType.
	objectType := referenceType withoutReferences.
	
	"Make sure we have a pointer to the structure."
	self assert: (objectType isStructureType or: [objectType isObjectSlots]).
	(objectType isStructureType and: [referenceType isReferenceType not]) ifTrue: [
		self assert: referenceType isStructureType.
		objectPointer := allocaBuilder alloca: objectType ssaType.
		self store: receiver in: objectPointer
	].
	
	"Get the slot pointer"
	slot := objectType slotNamed: message selector allButLast.
	
	"Convert the slot value"
	newValue := self visitNode: message arguments first.
	newValueType := message arguments first type.
	newValue := self coerceImplicitly: newValue type: newValueType to: slot type at: message.

	"Set the slot value"	
	slotPointer := slot emitSSASlotReferenceOf: objectPointer builder: builder at: message.
	self store: newValue in: slotPointer.
	
	"Return the slot pointer"
	^ slotPointer