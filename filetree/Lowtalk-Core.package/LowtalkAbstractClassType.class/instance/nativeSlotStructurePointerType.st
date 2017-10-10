slots
nativeSlotStructurePointerType
	^ nativeSlotStructurePointerType ifNil: [ nativeSlotStructurePointerType := compilationTarget pointerTo: self nativeSlotStructureType ]