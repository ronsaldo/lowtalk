slots
applySlotsLayout
	| layoutBuildingBlock |
	objectSlots := slotsList select: [ :slot | slot type isAnyDynamicObjectType ].
	nativeSlots := slotsList reject: [ :slot | slot type isAnyDynamicObjectType ].

	contentSize := 0.
	contentAlignment := 1.
		
	layoutBuildingBlock := [ :slot :index |
		contentSize := contentSize alignedTo: slot type alignment.
		contentAlignment := contentAlignment max: slot type alignment.
		slot
			index: index - 1;
			offset: contentSize.
		contentSize := contentSize + slot type size.
	].

	"Layout the dynamic object pointers (Inspected by GC)"
	objectSlots doWithIndex: layoutBuildingBlock.
	contentSize := contentSize alignedTo: contentAlignment.
	
	"Layout the native fields (Not inspected by GC)"
	nativeContentOffset := contentSize.
	nativeSlots doWithIndex: layoutBuildingBlock.
	contentSize := contentSize alignedTo: contentAlignment.
	nativeContentSize := contentSize - nativeContentOffset.
	
	nativeSlots do: [ :slot | slot ssaReceiverCastType: self nativeSlotStructurePointerType ].
	self selectProperLayout.
