slots
buildSlots
	classObject ifNotNil: [ ^ self importSlots ].
	^ super buildSlots