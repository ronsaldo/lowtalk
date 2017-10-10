slots
buildNativeSlotsStructureType
	self assert: nativeSlots isNotNil.
	
	nativeSlotStructureType := SLVMStructureType new.
	nativeSlotStructureType name: self validName;
		kind: SLVMStructureType genericKind;
		types: (nativeSlots collect: [:slot | slot type ssaType]);
		names: (nativeSlots collect: #validStructureFieldName).
