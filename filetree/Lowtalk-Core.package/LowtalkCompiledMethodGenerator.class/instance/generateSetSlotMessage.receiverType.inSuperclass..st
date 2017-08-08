inline messages
generateSetSlotMessage: message receiverType: receiverType inSuperclass: inSuperclass
	| referenceType structureType slot newValue newValueType setSlotSelector |
	self assert: message arguments size = 1.
	referenceType := receiverType.
	structureType := referenceType withoutReferences.
	self assert: structureType isStructureType.

	setSlotSelector := #lowtalkRefSetField:value:.
	referenceType isReferenceType ifFalse: [
		setSlotSelector := #lowtalkSetField:value:
	].

	"Get the slot name"
	slot := structureType slotNamed: message selector allButLast.
	irBuilder pushLiteral: slot.

	"Convert the slot value"
	newValue := self visitNode: message arguments first.
	newValueType := message arguments first type.
	self coerceImplicitlyFrom: newValueType to: slot type at: message.

	irBuilder send: setSlotSelector