accessing
slotsList
	slotsList ifNil: [ self buildSlots ].
	^ slotsList