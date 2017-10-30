slots
slotNamed: slotName ifAbsent: aBlock
	^ objectType slots at: slotName ifAbsent: aBlock
	