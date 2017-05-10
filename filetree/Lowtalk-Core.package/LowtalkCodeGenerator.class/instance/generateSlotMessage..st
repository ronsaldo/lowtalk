messages
generateSlotMessage: message
	| reference referenceType structureType slot |
	reference := message receiver accept: self.
	referenceType := message receiver type.
	structureType := referenceType withoutReferences.
	
	slot := structureType slotNamed: message selector.
	^ builder getReference: reference element: (builder constInt: slot index)