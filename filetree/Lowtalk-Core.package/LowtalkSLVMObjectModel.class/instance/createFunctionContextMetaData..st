visiting
createFunctionContextMetaData: function
	| result module header slotType slotConstants resultConstant |
	module := function module.
	result := compiler objectModel convertMethodContextMetadataFunction value: function value: (function dynamicLiterals collect: #value).
	
	header := result header asSSAConstantValueIn: module.
	slotType := result slotType.
	slotConstants := result slots collect: [ :slotValue | slotType convertValue: slotValue toSSAConstantWith: compiler ] as: Array.
	slotConstants := SLVMConstant array: result slotsType ssaType slots: slotConstants.
	
	resultConstant := SLVMConstant structure: result ssaValueType slots: { header . slotConstants }.
	^ resultConstant