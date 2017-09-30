module construction
doConvertSSADynamicConstantValue: value inModule: module
	| variableName convertedObject valueType variable header slotType slotConstants unmangledName |
	convertedObject := value asLowtalkObjectInstanceWith: self.
	convertedObject ifNil: [ ^ self convertDynamicObjectSSAConstant: convertedObject ].
	convertedObject isSLVMObject ifTrue: [ ^ convertedObject ].
	isSandboxed ifFalse: [ 
		^ SLVMConstantValue type: compilationTarget dynamicObjectType value: module
	].
	
	variableName := objectInstanceVariableNameMap at: value ifAbsent: [ 
		metaclassVariableNameMap at: value ifPresent: [:instance | unmangledName := (unmangledSymbolMap at: instance) , '__meta'. (instance , '_meta') asSymbol] ifAbsent: [ nil ]
	].

	unmangledName ifNil: [ unmangledName := unmangledSymbolMap at: variableName ifAbsent: [ nil ] ].
	
	variableName ifNil: [ 
		variableName := self generateSymbol asSymbol.
		objectInstanceVariableNameMap at: value put: variableName.
	].

	variableName := (variableName , '_oiv') asSymbol.
	unmangledName ifNotNil: [ unmangledName := unmangledName , '__object_instance' ].
	
	self assert: convertedObject class == LowtalkObjectInstance.
	module globalNamed: variableName ifPresent: [ :result |
		^ SLVMConstant pointer: result castTo: compilationTarget dynamicObjectType
	].

	valueType := convertedObject ssaValueType.
	variable := SLVMGlobalVariable module: module name: variableName valueType: valueType storage: SLVMType genericStorage.
	variable customSection: #'.oop'.
		
	(variableName beginsWith: '__ltgs') ifTrue: [
		variable makePrivate.
		variable propertyAt: #omitDebugInformation put: true
	].
	unmangledName ifNotNil: [ variable unmangledName: unmangledName ].
	
	header := convertedObject header asSSAConstantValueIn: module.
	slotType := convertedObject slotType.
	slotConstants := convertedObject slots collect: [ :slotValue | slotType convertValue: slotValue toSSAConstantWith: self ] as: Array.
	slotConstants := SLVMConstant array: convertedObject slotsType ssaType slots: slotConstants.
	
	variable initialValue: (SLVMConstant structure: valueType slots: { header . slotConstants }).
	
	^ SLVMConstant pointer: variable castTo: compilationTarget dynamicObjectType
