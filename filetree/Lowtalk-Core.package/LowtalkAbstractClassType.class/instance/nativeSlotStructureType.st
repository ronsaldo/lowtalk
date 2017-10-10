slots
nativeSlotStructureType
	^ nativeSlotStructureType ifNil: [ self buildNativeSlotsStructureType . nativeSlotStructureType ]