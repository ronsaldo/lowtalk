slot accessing
lowtalkSetField: slotDescription value: aValue
	| slot |
	slot := slots at: slotDescription index + 1.
	slot value: aValue.
	^ slot