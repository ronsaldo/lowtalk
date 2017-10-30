slots
slotNamed: slotName ifPresent: aBlock
	^ objectType slots at: slotName ifPresent: aBlock
	