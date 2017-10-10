as yet unclassified
convertSlots
	^ (objectSlots collect: [ :slot | InstanceVariableSlot named: slot name ]) ,
	  (nativeSlots collect: [:slot | (SLVMStructureFieldSlot named: slot name) type: slot type ssaType])
