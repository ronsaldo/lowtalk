module construction
doConvertSSADynamicConstantValue: value inModule: module
	| variableName convertedObject valueType variable unmangledName |
	convertedSSAObjects at: value ifPresent: [ :ssaObject | ^ ssaObject ].
	
	convertedObject := value asLowtalkObjectInstanceWith: self.
	convertedObject ifNil: [ ^ self convertDynamicObjectSSAConstant: convertedObject ].
	convertedObject isSLVMObject ifTrue: [ ^ convertedObject ].
	isSandboxed ifFalse: [ 
		^ self recordObject: value convertedObject: convertedObject ssaValue: (SLVMConstantValue type: compilationTarget dynamicObjectType value: module)
	].

	convertedSSAObjects at: convertedObject ifPresent: [ :ssaObject | ^ ssaObject ].
	
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
		^ self recordObject: value convertedObject: convertedObject ssaValue: (SLVMConstant pointer: result castTo: compilationTarget dynamicObjectType)
	].

	valueType := convertedObject ssaValueType.
	variable := SLVMGlobalVariable module: module name: variableName valueType: valueType storage: SLVMType genericStorage.
	variable customSection: #'.oop'.
		
	(variableName beginsWith: '__ltgs') ifTrue: [
		variable makePrivate.
		variable propertyAt: #omitDebugInformation put: true
	].
	unmangledName ifNotNil: [ variable unmangledName: unmangledName ].

	objectBuilders at: convertedObject ifPresent: [ :builder |

		pendingObjectsInitializers add: [
			builder finishBuildingObject.
			variable initialValue: (self createObjectInstanceSSAData: convertedObject valueType: valueType inModule: module)
		]
	] ifAbsent: [ 
		variable initialValue: (self createObjectInstanceSSAData: convertedObject valueType: valueType inModule: module)
	].
	
	^ self recordObject: value convertedObject: convertedObject ssaValue: (SLVMConstant pointer: variable castTo: compilationTarget dynamicObjectType)
