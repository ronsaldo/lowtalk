slots
slotNamed: slotName ifPresent: aBlock
	^ self slots at: slotName ifPresent: aBlock
	