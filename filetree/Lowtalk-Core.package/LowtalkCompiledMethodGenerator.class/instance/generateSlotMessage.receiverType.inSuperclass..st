inline messages
generateSlotMessage: message receiverType: receiverType inSuperclass: inSuperclass
	| referenceType structureType slot getSlotSelector |
	self assert: message arguments size = 0.
	referenceType := receiverType.
	structureType := referenceType withoutReferences.
	self assert: structureType isStructureType.

	getSlotSelector := #lowtalkRefGetFieldRef:.
	referenceType isReferenceType ifFalse: [
		getSlotSelector := #lowtalkGetFieldRef:
	].

	"Get the slot name"
	slot := structureType slotNamed: message selector.
	irBuilder pushLiteral: slot.

	irBuilder send: getSlotSelector