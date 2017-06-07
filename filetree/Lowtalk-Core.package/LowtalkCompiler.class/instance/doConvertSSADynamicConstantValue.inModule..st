module construction
doConvertSSADynamicConstantValue: value inModule: module
	| variableName convertedObject valueType variable header slotType slotConstants |
	convertedObject := value asLowtalkObjectInstanceWith: self.
	convertedObject ifNil: [ ^ self convertDynamicObjectSSAConstant: convertedObject ].
	convertedObject isSLVMObject ifTrue: [ ^ convertedObject ].
	
	variableName := ((objectInstanceVariableNameMap at: value ifAbsentPut: [ self generateSymbol ]) , '_oiv') asSymbol.
	self assert: convertedObject class == LowtalkObjectInstance.
	module globalNamed: variableName ifPresent: [ :result |
		^ SLVMConstant pointer: result castTo: compilationTarget dynamicObjectType
	].

	valueType := convertedObject ssaValueType.
	variable := SLVMGlobalVariable module: module name: variableName valueType: valueType storage: SLVMType genericStorage.
	(variableName beginsWith: '__ltgs') ifTrue: [
		variable makePrivate
	].
	
	header := convertedObject header asSSAConstantValueIn: module.
	slotType := convertedObject slotType.
	slotConstants := convertedObject slots collect: [ :slotValue | slotType convertValue: slotValue toSSAConstantWith: self ] as: Array.
	slotConstants := SLVMConstant array: convertedObject slotsType ssaType slots: slotConstants.
	
	variable initialValue: (SLVMConstant structure: valueType slots: { header . slotConstants }).
	
	^ SLVMConstant pointer: variable castTo: compilationTarget dynamicObjectType
