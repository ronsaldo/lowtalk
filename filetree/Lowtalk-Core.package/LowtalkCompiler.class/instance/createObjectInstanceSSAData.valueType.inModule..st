module construction
createObjectInstanceSSAData: objectInstance valueType: valueType inModule: module
	| header slotType slotConstants |
	header := objectInstance header asSSAConstantValueIn: module.
	slotType := objectInstance slotType.
	slotConstants := objectInstance slots collect: [ :slotValue | slotType convertValue: slotValue toSSAConstantWith: self ] as: Array.
	
	slotConstants := SLVMConstant array: objectInstance slotsType ssaType slots: slotConstants.
	^ SLVMConstant structure: valueType slots: { header . slotConstants }
