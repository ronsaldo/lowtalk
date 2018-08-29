Class {
	#name : #LowtalkCompiler,
	#superclass : #LowtalkBObject,
	#instVars : [
		'globalEnvironment',
		'currentDirectory',
		'compilerEnvironment',
		'compilationTarget',
		'pendingObjects',
		'ssaModule',
		'objectType',
		'integerLiteralType',
		'floatLiteralType',
		'rationalLiteralType',
		'stringLiteralType',
		'symbolLiteralType',
		'voidType',
		'compileTimeType',
		'intPointerType',
		'uintPointerType',
		'booleanType',
		'nilType',
		'globalBuilder',
		'objectModel',
		'booleanLiteralType',
		'objectInstanceVariableNameMap',
		'gensymCount',
		'byteType',
		'objectSSAValueMap',
		'valueConstantMap',
		'objectInstanceVariableMap',
		'metaclassVariableNameMap',
		'unmangledSymbolMap',
		'debugLocationDictionary',
		'debugSourceFileDictionary',
		'thisContextType',
		'capturedCompileTimeVariables',
		'characterLiteralType',
		'lazySelectors',
		'profilingInterpreter',
		'doubleType',
		'optimizationLevel',
		'verbose',
		'importedImageLiteralVariables',
		'isSandboxed',
		'importedImageClasses',
		'finalCodeGenerator',
		'classTypesForObjects',
		'classBuilder',
		'structureBuilder',
		'objectBuilders',
		'pendingObjectsInitializers',
		'convertedSSAObjects',
		'specialSelfType',
		'specialSelfInstanceType'
	],
	#category : 'Lowtalk-Core-FrontEnd'
}

{ #category : #accessing }
LowtalkCompiler class >> compilationTarget: aCompilationTarget [
	^ self basicNew initializeWithCompilationTarget: aCompilationTarget; yourself
]

{ #category : #accessing }
LowtalkCompiler class >> new [
	^ self compilationTarget: SLVM32BitsPointerCompilationTarget new.
]

{ #category : #adding }
LowtalkCompiler >> addPendingObject: aGlobalObject [
	pendingObjects add: aGlobalObject
]

{ #category : #converting }
LowtalkCompiler >> asLowtalkObjectInstanceWith: aCompiler [
	self flag: 'Try to do something better'.
	^ nil
]

{ #category : #types }
LowtalkCompiler >> booleanLiteralType [
	^ booleanLiteralType
]

{ #category : #types }
LowtalkCompiler >> booleanType [
	^ booleanType
]

{ #category : #'module construction' }
LowtalkCompiler >> buildModule [
	| toProcess objectToFinish |
	self log: 'Building module'.
	objectToFinish := SLVMOrderedInsertionSet new.
	
	[ pendingObjects isNotEmpty ] whileTrue: [
		toProcess := pendingObjects asArray.
		pendingObjects removeAll.
		objectToFinish addAll: toProcess.
		toProcess do: #prepareToCompile.
		toProcess do: #compileElement.
	].

	[ pendingObjectsInitializers isNotEmpty ] whileTrue: [
		toProcess := pendingObjectsInitializers asArray.
		pendingObjectsInitializers removeAll.
		toProcess do: #value
	].

	self assert: pendingObjects isEmpty.

	objectToFinish do: #finishCompiling.
	self assert: pendingObjects isEmpty.
	
	
]

{ #category : #types }
LowtalkCompiler >> byteType [
	^ byteType
]

{ #category : #types }
LowtalkCompiler >> characterLiteralType [
	^ characterLiteralType
]

{ #category : #accessing }
LowtalkCompiler >> classBuilder [
	^ classBuilder
]

{ #category : #'as yet unclassified' }
LowtalkCompiler >> classTypeForObject: anObject [
	^ classTypesForObjects at: anObject
]

{ #category : #accessing }
LowtalkCompiler >> compilationTarget [
	<compileTime>
	^ compilationTarget
]

{ #category : #compiling }
LowtalkCompiler >> compileError: errorString format: formatElements [
	<compileTime>
	<lazy>
	
	errorString node semanticError: errorString value format: formatElements value
]

{ #category : #types }
LowtalkCompiler >> compileTimeType [
	^ compileTimeType
]

{ #category : #'module construction' }
LowtalkCompiler >> convertCapturedCompileTimeVariable: compileTimeVariable [
	| valueType variableName variable |
	capturedCompileTimeVariables at: compileTimeVariable ifPresent: [ :result | ^ result ].
	
	valueType := compileTimeVariable valueType.
	valueType isBlockType ifTrue: [ 
		self flag: 'HACK: For now we are just returning its value'.
		^ self convertDynamicObjectSSAConstant: (compileTimeVariable value).
	].

	self flag: 'Support debugging scopes'.

	variableName := (self generateSymbol , '_compile_time_capture') asSymbol.	
	variable := SLVMGlobalVariable module: ssaModule name: variableName valueType: valueType ssaType storage: SLVMType genericStorage.
	variable makePrivate;
		shouldBePromotedToConstant: true;
		propertyAt: #omitDebugInformation put: true.
	valueType isAnyDynamicObjectType ifTrue: [
		variable customSection: #'.oopRef'
	].
	variable propertyAt: #binding put: compileTimeVariable capturedBinding.
	capturedCompileTimeVariables at: compileTimeVariable put: variable.
	
	variable initialValue: (valueType convertValue: compileTimeVariable value toSSAConstantWith: self).
	^ variable
	
]

{ #category : #'as yet unclassified' }
LowtalkCompiler >> convertDebugPosition: aPosition [
	^ debugLocationDictionary at: aPosition ifAbsentPut: [ SLVMDebugLocation new
			sourceFile: (self convertDebugSourceFile: aPosition collection);
			start: aPosition start;
			stop: aPosition stop;
			startLine: aPosition line;
			startColumn: aPosition column;
			endLine: aPosition endLine;
			endColumn: aPosition endColumn;
			collection: aPosition collection;
			yourself ]
]

{ #category : #'as yet unclassified' }
LowtalkCompiler >> convertDebugSourceFile: aSourceCollection [
	| sourceRef |
	^ debugSourceFileDictionary at: aSourceCollection ifAbsentPut: [ 
		sourceRef := (aSourceCollection ifNil: ['generated'] ifNotNil: [aSourceCollection name]) asFileReference.
		SLVMDebugSourceFile new
			directory: sourceRef parent fullName;
			name: sourceRef basename
	]
]

{ #category : #'module construction' }
LowtalkCompiler >> convertDynamicObjectSSAConstant: value [
	^ compilationTarget objectModel convertConstantValue: value inModule: ssaModule
]

{ #category : #compiling }
LowtalkCompiler >> convertParseFailure: aFailure collection: collection [
	| position |
	aFailure isPetitFailure ifFalse: [ ^ self ].
	position := LowtalkASTPosition new collection: collection; start: aFailure position; stop: aFailure position.
	LTCParseError new signal: position asString , ': ' , aFailure message.
]

{ #category : #compiling }
LowtalkCompiler >> createEnvironment [

	compilerEnvironment := LowtalkNamespace empty name: #_Compiler.
	isSandboxed := compilationTarget isCurrentImage not.
	compilationTarget isCurrentImage ifTrue: [
		compilerEnvironment parent: (LowtalkImageEnvironment new environment: self class environment)
	].

	compilerEnvironment
		compileTimeOnly: true;
		compiler: self;
		setCompileTimeVariable: #Compiler value: self;
		setCompileTimeVariable: #Structure value: (LowtalkStructureBuilder new compiler: self);
		setCompileTimeVariable: #Union value: (LowtalkUnionBuilder new compiler: self);
		setCompileTimeVariable: #PackedStructure value: (LowtalkPackedStructureBuilder new compiler: self);
		setCompileTimeVariable: #Namespace value: (LowtalkNamespaceBuilder new compiler: self);
		setCompileTimeVariable: #Global value: (globalBuilder := LowtalkGlobalBuilder new compiler: self);
		setCompileTimeVariable: #Constant value: (LowtalkConstantBuilder new compiler: self).
	
	compilerEnvironment
		setCompileTimeVariable: #Class value: (LowtalkClassBuilder new compiler: self).
	
	LowtalkType addStandardTypesToEnvironment: compilerEnvironment target: compilationTarget.

	voidType := (compilerEnvironment lookSymbol: #Void) value.
	nilType := (compilerEnvironment lookSymbol: #_Nil) value.
	objectType := (compilerEnvironment lookSymbol: #_DynamicObject) value.
	booleanLiteralType := (compilerEnvironment lookSymbol: #_BooleanLiteral) value.
	characterLiteralType := (compilerEnvironment lookSymbol: #_CharacterLiteral) value.
	integerLiteralType := (compilerEnvironment lookSymbol: #_IntegerLiteral) value.
	floatLiteralType := (compilerEnvironment lookSymbol: #_FloatLiteral) value.
	rationalLiteralType := (compilerEnvironment lookSymbol: #_RationalLiteral) value.
	stringLiteralType := (compilerEnvironment lookSymbol: #_StringLiteral) value.
	symbolLiteralType := (compilerEnvironment lookSymbol: #_SymbolLiteral) value.
	uintPointerType := (compilerEnvironment lookSymbol: #UIntPointer) value.
	intPointerType := (compilerEnvironment lookSymbol: #IntPointer) value.
	booleanType := (compilerEnvironment lookSymbol: #BooleanBit) value.
	byteType := (compilerEnvironment lookSymbol: #UInt8) value.
	doubleType := (compilerEnvironment lookSymbol: #Float64) value.
	thisContextType  := (compilerEnvironment lookSymbol: #_ThisContext) value.
	compileTimeType := LowtalkCompileTimeType target: compilationTarget.
	classBuilder := (compilerEnvironment lookSymbol: #Class) value.
	structureBuilder := (compilerEnvironment lookSymbol: #Structure) value.

	specialSelfType := (compilerEnvironment lookSymbol: #_SelfType) value.
	specialSelfInstanceType := (compilerEnvironment lookSymbol: #_SelfInstanceType) value.

	globalEnvironment := 	(LowtalkNamespace parent: compilerEnvironment) name: #_GlobalNamespace.
	globalEnvironment
		compiler: self;
		"setCompileTimeVariable: compilerEnvironment name value: compilerEnvironment;"
		setSymbol: globalEnvironment name value: globalEnvironment
		"setCompileTimeVariable: globalEnvironment name value: globalEnvironment".
		
	compilerEnvironment
		setCompileTimeVariable: globalEnvironment name value: globalEnvironment.
]

{ #category : #'module construction' }
LowtalkCompiler >> createObjectInstanceSSAData: objectInstance valueType: valueType inModule: module [
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

]

{ #category : #organization }
LowtalkCompiler >> declarePackage: aPackageName [
	<compileTime>
	RPackage organizer registerPackageNamed: aPackageName asSymbol
]

{ #category : #accessing }
LowtalkCompiler >> defaultCallingConvention [
	^ #smalltalk
]

{ #category : #'module construction' }
LowtalkCompiler >> doConvertSSADynamicConstantValue: value inModule: module [
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

]

{ #category : #compiling }
LowtalkCompiler >> doEvaluateFileNamed: aFileName [
	| fileEnvironment |
	fileEnvironment := LowtalkLocalEnvironment parent: globalEnvironment.
	self doEvaluateFileNamed: aFileName inContext: fileEnvironment
]

{ #category : #compiling }
LowtalkCompiler >> doEvaluateFileNamed: aFileName inContext: aLowtalkContext [
	| ast result fileReference oldDirectory contents |
	fileReference := currentDirectory resolve: aFileName asFileReference.
	oldDirectory := currentDirectory.
	currentDirectory := fileReference parent.

	[ 
		contents := fileReference contents asLowtalkCollectionWithContext.
		contents name: fileReference fullName.

		ast := LowtalkParser parse: contents.
		self convertParseFailure: ast collection: contents.
		result := LowtalkEvaluator evaluateValue: ast environment: aLowtalkContext.
		^ result
	] ensure: [  currentDirectory := oldDirectory ]

]

{ #category : #types }
LowtalkCompiler >> doubleType [
	^ doubleType
]

{ #category : #compiling }
LowtalkCompiler >> evaluateFileNamed: aFileName [
	<compileTime>
	| evaluationTime result |
	^ self profilingInterpreter ifFalse: [ 
		self doEvaluateFileNamed: aFileName
	] ifTrue: [ 
		evaluationTime := [ result := self doEvaluateFileNamed: aFileName ] timeToRun.
		self log: '{1} evaluation time: {2} ms' format: {aFileName . evaluationTime asMilliSeconds asString}.
		result
	].

	
]

{ #category : #compiling }
LowtalkCompiler >> evaluateFileNamedInThisContext: aFileName [
	<compileTime>
	<lazy>
	| evaluationTime result |
	^ self profilingInterpreter ifFalse: [ 
		self doEvaluateFileNamed: aFileName value inContext: thisContext lowtalkContext
	] ifTrue: [ 
		evaluationTime := [ result := self doEvaluateFileNamed: aFileName ] timeToRun.
		self log: '{1} evaluation time: {2} ms' format: {aFileName . evaluationTime asMilliSeconds asString}.
		result
	].

	
]

{ #category : #compiling }
LowtalkCompiler >> evaluateFileNamedInThisContext: aFileName inContext: aLowtalkContext [
	<compileTime>
	| evaluationTime result |
	^ self profilingInterpreter ifFalse: [ 
		self doEvaluateFileNamed: aFileName inContext: aLowtalkContext
	] ifTrue: [ 
		evaluationTime := [ result := self doEvaluateFileNamed: aFileName ] timeToRun.
		self log: '{1} evaluation time: {2} ms' format: {aFileName . evaluationTime asMilliSeconds asString}.
		result
	].

	
]

{ #category : #compiling }
LowtalkCompiler >> evaluateString: aString [
	<compileTime>
	| ast stringEnvironment contents |
	contents := aString asLowtalkCollectionWithContext.
	ast := LowtalkParser parse: contents.
	self convertParseFailure: ast collection: contents.
	stringEnvironment := LowtalkLocalEnvironment parent: globalEnvironment.
	^ LowtalkEvaluator evaluateValue: ast environment: stringEnvironment.
]

{ #category : #accessing }
LowtalkCompiler >> finalCodeGenerator [
	^ finalCodeGenerator ifNil: [ finalCodeGenerator := compilationTarget createCodeGenerator
		optimizationLevel: optimizationLevel;
		yourself ]
]

{ #category : #types }
LowtalkCompiler >> floatLiteralType [
	^ floatLiteralType
]

{ #category : #initialization }
LowtalkCompiler >> gatherLazySelectors [
	lazySelectors := Set new.

	LowtalkBObject withAllSubclassesDo: [ :sc |
		(Pragma allNamed: #lazy in: sc) do: [ :pragma |
			lazySelectors add: pragma method selector
		]
	].
]

{ #category : #'as yet unclassified' }
LowtalkCompiler >> generateCompiledMethod: method [
	| ssaFunctionMetadata compiledMethodBinding |
	self assert: isSandboxed not.
	ssaFunctionMetadata := self generateInterpreterMethod: method.
	compiledMethodBinding := self finalCodeGenerator translateFinalModuleElement: ssaFunctionMetadata sourceMethod.
	compiledMethodBinding value propertyAt: #compilerClass put: LowtalkMethodCompiler.
	^ compiledMethodBinding value

]

{ #category : #'as yet unclassified' }
LowtalkCompiler >> generateFunction: ssaFunction value: functionValue [
	LowtalkCodeGenerator new compiler: self;
		generateFunction: ssaFunction value: functionValue
]

{ #category : #'as yet unclassified' }
LowtalkCompiler >> generateInterpreterMethod: method [
	| functionType ssaValue ssaMetadata |
	objectSSAValueMap at: method ifPresent: [ :oldValue | ^ oldValue ].
	objectInstanceVariableMap at: method ifPresent: [ :variable | ^ variable ssaValue ].

	functionType := method type.
	functionType isBlockType ifTrue: [ functionType := functionType functionType ].

	ssaValue := SLVMFunction pointerSize: compilationTarget pointerSize functionType: functionType ssaType.
	ssaValue compilationTarget: compilationTarget.
	ssaValue gcStrategy: #lowtalk.

	method publicSymbol ifNotNil: [ 
		ssaValue name: method publicSymbol;
			makeExternal.
	] ifNil: [
		ssaValue makePrivate.
	].
	
	method primitive ifNotNil: [ ssaValue primitive: method ].
	method inlineMode ifNotNil: [ ssaValue inlineMode: method inlineMode ].
	method unmangledName ifNotNil: [ 
		ssaValue unmangledName: method unmangledName
	] ifNil: [ 
		(method selector isNotNil and: [method methodClass isNotNil]) ifTrue: [ 
			ssaValue unmangledName: method methodClass name , '>>' , method selector printString
		]
	].
	self ssaModule add: ssaValue.
	(isSandboxed not or: [ compilationTarget emittingDebugInformation ]) ifTrue: [
		ssaValue debugSourceLocation: (self convertDebugPosition: method node position).
	].

	ssaMetadata := ssaValue compiledMethodMetaDataValue.
	self mapValue: method toSSAValue: ssaMetadata.
	self generateFunction: ssaValue value: method.
	
	^ ssaMetadata
]

{ #category : #initialization }
LowtalkCompiler >> generateSymbol [
	gensymCount := gensymCount + 1.
	^ ('__ltgsym' , gensymCount asString) asSymbol
]

{ #category : #'as yet unclassified' }
LowtalkCompiler >> getSSAValueAssociatedWith: value [
	self halt
]

{ #category : #builders }
LowtalkCompiler >> globalBuilder [
	^ globalBuilder
]

{ #category : #'as yet unclassified' }
LowtalkCompiler >> importImageClassType: aBehavior [
	| result |
	self assert: isSandboxed not.
	^ importedImageClasses at: aBehavior ifAbsentPut: [
		result :=
		(LowtalkImageBehaviorType target: compilationTarget)
			compiler: self;
			classObject: aBehavior.
		self addPendingObject: result.
		result
	]
]

{ #category : #'as yet unclassified' }
LowtalkCompiler >> importImageClassType: aBehavior importedValue: aValue [
	self assert: isSandboxed not.
	^ importedImageClasses at: aBehavior put: aValue
]

{ #category : #'as yet unclassified' }
LowtalkCompiler >> importImageLiteralVariable: aLiteralVariable [
	self assert: isSandboxed not.
	^ importedImageLiteralVariables at: aLiteralVariable ifAbsentPut: [
		LowtalkImageVariable new
			binding: aLiteralVariable;
			compiler: self;
			type: self objectType
	]
]

{ #category : #initialization }
LowtalkCompiler >> initializeWithCompilationTarget: aCompilationTarget [
	compilationTarget := aCompilationTarget.
	profilingInterpreter := false.
	verbose := false.
	compilationTarget isCurrentImage ifTrue: [ 
		objectModel := LowtalkInImageObjectModel new compiler: self.
	] ifFalse: [ 
		objectModel := LowtalkSandboxObjectModel new compiler: self.
	].
	compilationTarget objectModel: (LowtalkSLVMObjectModel new compiler: self).
	self createEnvironment.
	self gatherLazySelectors.
	currentDirectory := FileSystem workingDirectory.
	pendingObjects := SLVMOrderedInsertionSet new.
	self addPendingObject: globalEnvironment.
	
	objectInstanceVariableNameMap := IdentityDictionary new.
	metaclassVariableNameMap := IdentityDictionary new.
	objectSSAValueMap := IdentityDictionary new.
	objectInstanceVariableMap := IdentityDictionary new.
	unmangledSymbolMap := IdentityDictionary new.
	debugLocationDictionary := Dictionary new.
	debugSourceFileDictionary := IdentityDictionary new.
	capturedCompileTimeVariables := IdentityDictionary new.
	importedImageLiteralVariables := IdentityDictionary new.
	importedImageClasses := IdentityDictionary new.
	classTypesForObjects := IdentityDictionary new.
	objectBuilders := IdentityDictionary new.
	convertedSSAObjects := IdentityDictionary new.
	pendingObjectsInitializers := OrderedCollection new.
	gensymCount := 0.
	
	optimizationLevel := 0.
]

{ #category : #types }
LowtalkCompiler >> intPointerType [
	^ intPointerType
]

{ #category : #types }
LowtalkCompiler >> integerLiteralType [
	^ integerLiteralType
]

{ #category : #initialization }
LowtalkCompiler >> isLazySelector: aSelector [
	^ lazySelectors includes: aSelector
]

{ #category : #testing }
LowtalkCompiler >> isRegisteredClassObject: anObject [
	^ classTypesForObjects includesKey: anObject
]

{ #category : #accessing }
LowtalkCompiler >> isSandboxed [
	<compileTime>
	^ isSandboxed
]

{ #category : #compiling }
LowtalkCompiler >> log: string [
	verbose ifTrue: [
		FileStream stdout nextPutAll: string; lf.
	]
]

{ #category : #compiling }
LowtalkCompiler >> log: format format: formatArgs [
	self log: (format format: formatArgs)
]

{ #category : #'as yet unclassified' }
LowtalkCompiler >> mapValue: value toSSAValue: ssaValue [
	objectSSAValueMap at: value put: ssaValue
]

{ #category : #'compile time objects' }
LowtalkCompiler >> newArray: size [
	<compileTime>
	^ Array new: size
]

{ #category : #'compile time objects' }
LowtalkCompiler >> newDictionary [
	<compileTime>
	^ Dictionary new
]

{ #category : #'compile time objects' }
LowtalkCompiler >> newOrderedCollection [
	<compileTime>
	^ OrderedCollection new
]

{ #category : #types }
LowtalkCompiler >> nilType [
	^ nilType
]

{ #category : #accessing }
LowtalkCompiler >> objectModel [
	<compileTime>
	^ objectModel
]

{ #category : #types }
LowtalkCompiler >> objectType [
	^ objectType
]

{ #category : #accessing }
LowtalkCompiler >> operatingSystemName [
	<compileTime>
	^ compilationTarget operatingSystemName
]

{ #category : #accessing }
LowtalkCompiler >> optimizationLevel [
	^ optimizationLevel
]

{ #category : #accessing }
LowtalkCompiler >> optimizationLevel: anOptimizationLevel [
	optimizationLevel := anOptimizationLevel
]

{ #category : #compiling }
LowtalkCompiler >> parseString: aString [
	<compileTime>
	| ast contents |
	contents := aString asLowtalkCollectionWithContext.
	ast := LowtalkParser parse: contents.
	self convertParseFailure: ast collection: contents.
	^ ast
]

{ #category : #utility }
LowtalkCompiler >> print: aString [
	<compileTime>
	Transcript print: aString
]

{ #category : #utility }
LowtalkCompiler >> printLine: aString [
	<compileTime>
	Transcript print: aString; cr
]

{ #category : #accessing }
LowtalkCompiler >> profilingInterpreter [
	^ profilingInterpreter
]

{ #category : #accessing }
LowtalkCompiler >> profilingInterpreter: aBoolean [
	profilingInterpreter := aBoolean
]

{ #category : #types }
LowtalkCompiler >> rationalLiteralType [
	^ rationalLiteralType
]

{ #category : #'as yet unclassified' }
LowtalkCompiler >> recordObject: value convertedObject: convertedObject ssaValue: ssaValue [
	convertedSSAObjects at: value put: ssaValue.
	convertedSSAObjects at: convertedObject put: ssaValue.
	^ ssaValue
]

{ #category : #'as yet unclassified' }
LowtalkCompiler >> registerClassType: aClassType for: anObject [
	^ classTypesForObjects at: anObject put: aClassType
]

{ #category : #'module construction' }
LowtalkCompiler >> registerMangledNameOf: variable [
	| result |
	result := variable mangledName asSymbol.
	unmangledSymbolMap at: result put: variable name asSymbol.
	^ result
]

{ #category : #'as yet unclassified' }
LowtalkCompiler >> registerObject: anObject builder: aBuilder [
	^ objectBuilders at: anObject put: aBuilder
]

{ #category : #'module construction' }
LowtalkCompiler >> registerVariable: variable objectInstanceValue: object [
	objectInstanceVariableNameMap at: object ifPresent: [ ^ self ] ifAbsentPut: [ self registerMangledNameOf: variable ].
	objectInstanceVariableMap at: object ifAbsentPut: [ variable ].
	
	(object isLowtalkBObject and: [ object isLowtalkType and: [ object isAggregateType and: [object bindingVariable isNil ]]]) ifTrue: 	[
		object bindingVariable: variable.
	]
]

{ #category : #'as yet unclassified' }
LowtalkCompiler >> registerVariableName: variable forMetaClass: metaclassObject [
	metaclassVariableNameMap at: metaclassObject ifAbsentPut: [ self registerMangledNameOf: variable ]
]

{ #category : #types }
LowtalkCompiler >> specialSelfInstanceType [
	^ specialSelfInstanceType
]

{ #category : #types }
LowtalkCompiler >> specialSelfType [
	^ specialSelfType
]

{ #category : #'memory barriers' }
LowtalkCompiler >> ssaIncreaseReference [
	^ objectModel increaseReference ifNil: [ ^ nil ] ifNotNil: [ :function | function ssaValue ]
]

{ #category : #accessing }
LowtalkCompiler >> ssaModule [
	^ ssaModule ifNil: [ssaModule := SLVMModule new compilationTarget: compilationTarget].
]

{ #category : #'memory barriers' }
LowtalkCompiler >> ssaReadBarrier [
	^ objectModel readBarrier ifNil: [ nil ] ifNotNil: [ :function | function ssaValue ]
]

{ #category : #'memory barriers' }
LowtalkCompiler >> ssaReleaseReference [
	^ objectModel releaseReference ifNil: [ ^ nil ] ifNotNil: [ :function | function ssaValue ]
]

{ #category : #'as yet unclassified' }
LowtalkCompiler >> ssaValueForObject: object [
	^ objectSSAValueMap at: object ifAbsent: [ 
		(objectInstanceVariableMap at: object ifAbsent: [ self error: 'Expected a value stored in a variable' ]) ssaValue
	]
]

{ #category : #'memory barriers' }
LowtalkCompiler >> ssaWriteBarrier [
	^ objectModel writeBarrier ifNil: [ ^ nil ] ifNotNil: [ :function | function ssaValue ]
]

{ #category : #'memory barriers' }
LowtalkCompiler >> ssaWriteBarrierNoIncrement [
	^ objectModel writeBarrierNoIncrement ifNil: [ ^ nil ] ifNotNil: [ :function | function ssaValue ]
]

{ #category : #'as yet unclassified' }
LowtalkCompiler >> staticAssert: aBooleanExpression [
	<compileTime>
	<lazy>
	aBooleanExpression value ifFalse: [
		aBooleanExpression node semanticError: 'Static assert failure.'
	].
]

{ #category : #types }
LowtalkCompiler >> stringLiteralType [
	^ stringLiteralType
]

{ #category : #accessing }
LowtalkCompiler >> structureBuilder [
	^ structureBuilder
]

{ #category : #types }
LowtalkCompiler >> symbolLiteralType [
	^ symbolLiteralType
]

{ #category : #types }
LowtalkCompiler >> thisContextType [
	^ thisContextType
]

{ #category : #'module construction' }
LowtalkCompiler >> translateSSAConstant: value type: valueType [
	^ valueType convertValue: value toSSAConstantWith: self
]

{ #category : #types }
LowtalkCompiler >> uintPointerType [
	^ uintPointerType
]

{ #category : #accessing }
LowtalkCompiler >> verbose [
	^ verbose
]

{ #category : #accessing }
LowtalkCompiler >> verbose: aBoolean [
	verbose := verbose
]

{ #category : #types }
LowtalkCompiler >> voidType [
	^ voidType
]

{ #category : #'front end' }
LowtalkCompiler >> writeObjectToFileNamed: aFileName [
	| lowLevelModule |
	self buildModule;
		ssaModule.
	
	optimizationLevel > 0 ifTrue: [ 
		ssaModule optimizeGlobalVariables
	].

	lowLevelModule := ssaModule asLowLevelModuleWithOptimizationLevel: optimizationLevel.
	lowLevelModule asBinaryObject writeObjectToFileNamed: aFileName
]
