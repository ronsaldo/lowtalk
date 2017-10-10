accessing
nativeSlots
	nativeSlots ifNil: [ self buildSlots ].
	^ nativeSlots