module construction
createObjectInstanceSSAData: objectInstance valueType: valueType inModule: module
	| header slotType slotConstants |
	header := objectInstance header asSSAConstantValueIn: module.
	slotType := objectInstance slotType.
	objectInstance slots class == ByteArray ifTrue: [ 
		slotConstants := SLVMConstant array: objectInstance slotsType ssaType blob: objectInstance slots.
	] ifFalse: [ 
		slotConstants := objectInstance slots collect: [ :slotValue | slotType convertValue: slotValue toSSAConstantWith: self ] as: Array.
		slotConstants := SLVMConstant array: objectInstance slotsType ssaType slots: slotConstants.
	].
	
	^ SLVMConstant structure: valueType slots: { header . slotConstants }
