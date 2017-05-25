slots
slotNamed: slotName
	^ self slotNamed: slotName ifAbsent: [ self error: 'Slot not found' ]
	