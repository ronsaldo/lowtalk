slots
slotNamed: slotName ifAbsent: aBlock
	^ self slots at: slotName ifAbsent: aBlock
	