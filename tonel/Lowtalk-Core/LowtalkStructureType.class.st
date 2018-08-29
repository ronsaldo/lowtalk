Class {
	#name : #LowtalkStructureType,
	#superclass : #LowtalkType,
	#instVars : [
		'name',
		'fields',
		'fieldNames',
		'environment',
		'slots',
		'slotsExpression',
		'compiler',
		'pendingMethods',
		'methodDict',
		'category',
		'classObject',
		'allSlots',
		'methodSignatureDictionary',
		'organization',
		'bindingVariable',
		'minimalAlignment'
	],
	#classVars : [
		'StructureMetaMessageTypes'
	],
	#category : 'Lowtalk-Core-Types'
}

{ #category : #initialization }
LowtalkStructureType class >> initialize [
	StructureMetaMessageTypes := Dictionary newFromPairs: #(
		basicNew StructureNewObject
		new StructureNewObject
		basicNewValue StructureNew
		newValue StructureNew
		basicNewPointer StructureNewPointer
		newPointer StructureNewPointer
	)
]

{ #category : #comparing }
LowtalkStructureType >> = other [
	^ self == other
]

{ #category : #adding }
LowtalkStructureType >> addSlots: aCollectionOfSlots [
	aCollectionOfSlots ifNil: [ ^ self ].
	slots ifNil: [ slots := Dictionary new ].
	
	aCollectionOfSlots doWithIndex: [ :slot :index |
		slot index: index - 1.
		slots at: slot name ifPresent: [ 
			slot node semanticError: 'Structure {1} member name {1} is already in use.' format: { self validName . slot name printString }
		] ifAbsentPut: [ slot ].
	].

	allSlots := allSlots , aCollectionOfSlots.
	fields := fields , (aCollectionOfSlots collect: #type).
	fieldNames := fieldNames , (aCollectionOfSlots collect: #name).

]

{ #category : #accessing }
LowtalkStructureType >> alignment [
	^ self ssaType alignment
]

{ #category : #'instance creation' }
LowtalkStructureType >> basicNew [
	<compileTime>
	self flag: 'TODO: Put the structure value in a box.'.
	^ self basicNewValue
]

{ #category : #'instance creation' }
LowtalkStructureType >> basicNewValue [
	<compileTime>
	self slots.
	
	^ LowtalkStructureInstance basicNew 
		type: self;
		slots: (self fields collect: [:fieldType | LowtalkStructureInstanceSlotVariable new valueType: fieldType; value: fieldType defaultValue ]);
		yourself
]

{ #category : #accessing }
LowtalkStructureType >> binding [
	compiler isSandboxed ifTrue: [
		self halt
	] ifFalse: [
		^ self classObject binding
	]
]

{ #category : #accessing }
LowtalkStructureType >> bindingVariable [
	^ bindingVariable
]

{ #category : #accessing }
LowtalkStructureType >> bindingVariable: aVariable [
	bindingVariable := aVariable.
	(compiler isSandboxed not and: [ classObject isNotNil ]) ifTrue: [ 
		bindingVariable ssaBindingValue: classObject binding
	]
]

{ #category : #accessing }
LowtalkStructureType >> buildSSAType [
	self slots.
	ssaType := self ssaTypeClass new.
	ssaType name: self validName;
		kind: self ssaTypeClass genericKind;
		types: (fields collect: #ssaType);
		names: self validFieldNames;
		minimalAlignment: minimalAlignment.
	compiler isSandboxed ifFalse: [ ssaType behavior: self classObject ].
	^ ssaType
]

{ #category : #slots }
LowtalkStructureType >> buildSlots [
	self assert: slots isNil.
	slots := Dictionary new.
	self addSlots: slotsExpression value.
]

{ #category : #testing }
LowtalkStructureType >> canBeImplicitlyConvertedTo: targetType [
	targetType isDynamicObjectType ifTrue: [ ^ true ].
	^ super canBeImplicitlyConvertedTo: targetType
]

{ #category : #accessing }
LowtalkStructureType >> category [
	<compileTime>
	^ category
]

{ #category : #accessing }
LowtalkStructureType >> category: anObject [
	<compileTime>
	category := anObject
]

{ #category : #methods }
LowtalkStructureType >> category: categoryName methods: newMethods [
	<compileTime>
	newMethods do: [ :method |
		pendingMethods at: method selector put: method.
		organization at: method put: categoryName
	].

]

{ #category : #accessing }
LowtalkStructureType >> classObject [
	<compileTime>
	classObject ifNil: [ self createClassObject ].
	^ classObject
]

{ #category : #accessing }
LowtalkStructureType >> classObject: anObject [
	classObject := anObject
]

{ #category : #'lazy compilation' }
LowtalkStructureType >> compileElement [
	self concretizeAllPendingMethods.
]

{ #category : #accessing }
LowtalkStructureType >> compiler [
	^ compiler
]

{ #category : #accessing }
LowtalkStructureType >> compiler: anObject [
	compiler := anObject
]

{ #category : #methods }
LowtalkStructureType >> concreteMethodForMetaSelector: selector [
	^ self metaClass ifNotNil: [ :meta | meta concreteMethodForSelector: selector ]
]

{ #category : #methods }
LowtalkStructureType >> concreteMethodForSelector: selector [
	pendingMethods at: selector ifPresent: [ :pendingMethod | self concretizeMethod: pendingMethod ].
	^ methodDict at: selector ifAbsent: [ nil ]
]

{ #category : #methods }
LowtalkStructureType >> concretizeAllPendingMethods [
	pendingMethods values copy do: [ :pending | self concretizeMethod: pending ]
]

{ #category : #methods }
LowtalkStructureType >> concretizeMethod: aMethod [
	| actualMethod |
	(pendingMethods includesKey: aMethod selector) ifFalse: [ ^ self ].
	methodSignatureDictionary at: aMethod selector ifAbsentPut: [ aMethod methodSignatureForReceiverTypeValue: self ref ].
	actualMethod := aMethod compiledMethodForReceiverTypeValue: self ref.
	pendingMethods removeKey: aMethod selector.
	methodDict at: actualMethod selector put: actualMethod.
	self installMethod: actualMethod category: 	(organization at: aMethod ifAbsent: [ self defaultMethodCategory ]).
]

{ #category : #converting }
LowtalkStructureType >> convertValue: value toSSAConstantWith: aCompiler [
	^ value asSSAConstantValueIn: aCompiler ssaModule
]

{ #category : #accessing }
LowtalkStructureType >> createClassObject [
	compiler isSandboxed ifTrue: [ self createSandboxedClassObject ] ifFalse: [ self createInImageClassObject ]
]

{ #category : #'structure class' }
LowtalkStructureType >> createInImageClassObject [
	| layoutClass instanceSlots superClassObject |
	layoutClass := self inImageStructureLayoutClass.
	self slots.
	instanceSlots := allSlots collect: #asSLVMStructureFieldSlot.
	
	self flag: 'HACK: remove the methods from the class to avoid triggering recompilation with the wrong compiler.'.
	(name isNotNil and: [ Smalltalk globals includesKey: name ]) ifTrue: [ 
		(Smalltalk globals at: name) methodDict removeAll.
		(Smalltalk globals at: name) class methodDict removeAll.
	].

	superClassObject := SLVMInternalStructure.
	classObject := superClassObject classInstaller make: [ :builder |
		name ifNotNil: [
			builder name: name asSymbol
		].
		builder 
			superclass: superClassObject;
			layoutClass: layoutClass;
			slots: instanceSlots;
			sharedVariables: '';
			sharedPools: '';
			category: self category
	].
	
	classObject classLayout minimalAlignment: minimalAlignment.
	classObject _slvm_type: self ssaType.
	compiler importImageClassType: classObject importedValue: self.
	bindingVariable ifNotNil: [
		bindingVariable ssaBindingValue: classObject binding
	].
	self createPublicAccessors
]

{ #category : #'as yet unclassified' }
LowtalkStructureType >> createPublicAccessors [
	"TODO: Create the public accessors"
	self slots valuesDo: [ :slot |
		slot createPublicAccessorsOn: self
	]
]

{ #category : #'structure class' }
LowtalkStructureType >> createSandboxedClassObject [
	"TODO: Implement myself"
]

{ #category : #accessing }
LowtalkStructureType >> defaultSSAValueWith: builder [
	self slots.
	^ SLVMConstant structure: self ssaType
		slots: (allSlots collect: [ :s | s type defaultSSAValueWith: builder ])
]

{ #category : #accessing }
LowtalkStructureType >> defaultValue [
	^ self basicNew
]

{ #category : #coercions }
LowtalkStructureType >> dispatchArithmeticCoerceWith: otherType [
	^ otherType arithmeticCoerceWithStructureType: self
]

{ #category : #methods }
LowtalkStructureType >> doGetMethodSignatureForSelector: selector environment: anEnvironment [
	^ methodSignatureDictionary at: selector ifAbsent: [
		pendingMethods at: selector ifPresent: [ :method |
			methodSignatureDictionary at: selector put: (method methodSignatureForReceiverTypeValue: self ref)
		] ifAbsent: [nil].
	].
]

{ #category : #accessing }
LowtalkStructureType >> environment [
	^ environment
]

{ #category : #accessing }
LowtalkStructureType >> environment: anObject [
	environment := anObject
]

{ #category : #accessing }
LowtalkStructureType >> fieldNames [
	^ fieldNames
]

{ #category : #accessing }
LowtalkStructureType >> fieldNames: anObject [
	fieldNames := anObject
]

{ #category : #accessing }
LowtalkStructureType >> fields [
	slots ifNil: [ self buildSlots ].
	^ fields
]

{ #category : #accessing }
LowtalkStructureType >> fields: anObject [
	fields := anObject
]

{ #category : #'lazy compilation' }
LowtalkStructureType >> finishCompiling [
]

{ #category : #comparing }
LowtalkStructureType >> hash [
	^ self identityHash
]

{ #category : #'message dispatching' }
LowtalkStructureType >> image_metaClass [
	^ self classObject class asLowtalkTypeWith: compiler
]

{ #category : #'structure class' }
LowtalkStructureType >> inImageStructureLayoutClass [
	^ SLVMStructureLayout
]

{ #category : #initialization }
LowtalkStructureType >> initialize [
	super initialize.
	allSlots := #().
	fields := #().
	fieldNames := #().
	pendingMethods := OrderedDictionary new.
	methodSignatureDictionary := Dictionary new.
	methodDict := OrderedDictionary new.
	organization := IdentityDictionary new.
	minimalAlignment := 1.
	
]

{ #category : #methods }
LowtalkStructureType >> installMethod: aMethod category: methodCategory [
	| compiledMethod |
	compiler isSandboxed ifTrue: [ 
		self halt
	] ifFalse: [ 
		compiledMethod := compiler generateCompiledMethod: aMethod.
		classObject addAndClassifySelector: compiledMethod selector
			withMethod: compiledMethod
			inProtocol: methodCategory 
			notifying: nil.
		classObject instanceSide 
			noteCompilationOfMethod: compiledMethod 
			meta: classObject isClassSide.
	]

]

{ #category : #coercions }
LowtalkStructureType >> irCoerceImplicitlyTo: targetType with: builder at: node [
	targetType isDynamicObjectType ifTrue: [ ^ self ].
	^ super irCoerceImplicitlyTo: targetType with: builder at: node
]

{ #category : #testing }
LowtalkStructureType >> isAggregateType [
	^ true
]

{ #category : #testing }
LowtalkStructureType >> isStructureType [
	^ true
]

{ #category : #accessing }
LowtalkStructureType >> metaClass [
	^ compiler isSandboxed ifTrue: [ self sandbox_metaClass ] ifFalse: [ self image_metaClass ]
]

{ #category : #methods }
LowtalkStructureType >> methodSignatureForMetaSelector: selector environment: anEnvironment [
	^ self metaClass ifNotNil: [ :meta | meta methodSignatureForSelector: selector environment: anEnvironment ]
]

{ #category : #methods }
LowtalkStructureType >> methodSignatureForSelector: selector environment: anEnvironment [
	| result |
	result := self doGetMethodSignatureForSelector: selector environment: anEnvironment.
	result ifNotNil: [ ^ result ].
	^ nil
]

{ #category : #methods }
LowtalkStructureType >> methods: newMethods [
	<compileTime>
	self category: 'uncategorized' methods: newMethods
]

{ #category : #accessing }
LowtalkStructureType >> minimalAlignment [
	<compileTime>
	^ minimalAlignment
]

{ #category : #accessing }
LowtalkStructureType >> minimalAlignment: anAlignment [
	<compileTime>
	minimalAlignment := anAlignment
]

{ #category : #accessing }
LowtalkStructureType >> name [
	^ name
]

{ #category : #accessing }
LowtalkStructureType >> name: anObject [
	name := anObject
]

{ #category : #'instance creation' }
LowtalkStructureType >> new [
	<compileTime>
	self flag: 'TODO: Put the structure value in a box.'.
	^ self newValue
]

{ #category : #'instance creation' }
LowtalkStructureType >> newValue [
	<compileTime>
	^ self basicNew initialize
]

{ #category : #accessing }
LowtalkStructureType >> package [
	<compileTime>
	^ category
]

{ #category : #accessing }
LowtalkStructureType >> package: anObject [
	<compileTime>
	category := anObject
]

{ #category : #'lazy compilation' }
LowtalkStructureType >> prepareToCompile [
	"Force the creation of the class object"
	self classObject. 
]

{ #category : #printing }
LowtalkStructureType >> printOn: aStream [
	aStream nextPutAll: self validName
]

{ #category : #accessing }
LowtalkStructureType >> resultTypeForMetaSelector: selector message: messageNode compiler: aCompiler evaluator: evaluator [
	(#(basicNew new) includes: selector) ifTrue: [ ^ self ].
	(#(basicNewPointer newPointer) includes: selector) ifTrue: [ ^ self pointer ].
	^ super resultTypeForMetaSelector: selector message: messageNode compiler: aCompiler evaluator: evaluator
]

{ #category : #accessing }
LowtalkStructureType >> resultTypeForSelector: selector message: messageNode compiler: aCompiler evaluator: evaluator [
	| precedence |	
	precedence := selector precedence.
	(self concreteMethodForSelector: selector) ifNotNil: [ 
		self halt
	].
	
	precedence = 1 ifTrue: [
		self slotNamed: selector ifPresent: [ :slotDescription |
			^ slotDescription type ref
		]
	].
	precedence = 3 ifTrue: [
		self slotNamed: selector allButLast ifPresent: [ :slotDescription |
			^ slotDescription type ref
		]
	].

	^ super resultTypeForSelector: selector message: messageNode compiler: aCompiler evaluator: evaluator
]

{ #category : #'message dispatching' }
LowtalkStructureType >> sandbox_class [
	^ self metaClass
]

{ #category : #'message dispatching' }
LowtalkStructureType >> sandbox_metaClass [
	"TODO: Implement this"
	self halt
]

{ #category : #accessing }
LowtalkStructureType >> size [
	^ self ssaType size
]

{ #category : #slots }
LowtalkStructureType >> slotNamed: slotName [
	^ self slots at: slotName
	
]

{ #category : #slots }
LowtalkStructureType >> slotNamed: slotName ifAbsent: aBlock [
	^ self slots at: slotName ifAbsent: aBlock
	
]

{ #category : #slots }
LowtalkStructureType >> slotNamed: slotName ifPresent: aBlock [
	^ self slots at: slotName ifPresent: aBlock
	
]

{ #category : #slots }
LowtalkStructureType >> slots [
	slots ifNil: [ self buildSlots ].
	^ slots
]

{ #category : #slots }
LowtalkStructureType >> slots: slotsLazyValue [
	<compileTime>
	<lazy>
	| baseEnvironment definitionEnvironment |
	slots ifNotNil: [ slotsLazyValue semanticError: 'Cannot redefine the slots of a structure.' ].

	baseEnvironment := slotsLazyValue environment.
	definitionEnvironment := baseEnvironment namespaceEnvironment.

	self
		environment: baseEnvironment;
		slotsExpression: slotsLazyValue.
]

{ #category : #slots }
LowtalkStructureType >> slotsExpression [
	^ slotsExpression
]

{ #category : #slots }
LowtalkStructureType >> slotsExpression: anObject [
	slotsExpression := anObject
]

{ #category : #'special messages' }
LowtalkStructureType >> specialMessageTypeForMetaSelector: selector [
	StructureMetaMessageTypes at: selector ifPresent: [ :type | ^ type ].

	^ super specialMessageTypeForMetaSelector: selector
]

{ #category : #slots }
LowtalkStructureType >> specialMessageTypeForSelector: selector [
	self slots ifNotNil: [
		slots at: selector ifPresent: [ :slot | ^ slot specialSelectorType ].
		selector last = $: ifTrue: [ 
			slots at: selector allButLast ifPresent: [ :slot | ^ slot setterSpecialSelectorType ].
		]
	].

	^ super specialMessageTypeForSelector: selector

]

{ #category : #accessing }
LowtalkStructureType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	| temp |
	targetType isDynamicObjectType ifTrue: [
		^ builder structureToDynamicObjectCast: value target: targetType ssaType typeObject: (builder addDynamicLiteral: self)
	].

	(targetType isReferenceType and: [ targetType referenced == self ]) ifTrue: [
		temp := builder allocaBuilder alloca: self ssaType.
		builder store: value in: temp.
		^ temp
	].

	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node
]

{ #category : #accessing }
LowtalkStructureType >> ssaTypeClass [
	^ SLVMStructureType
]

{ #category : #accessing }
LowtalkStructureType >> validFieldNames [
	^ fields collectWithIndex: [ :f :i |
		i <= fieldNames size ifTrue: [ fieldNames at: i ] ifFalse: [ 'f' , i asString ]
	]
]

{ #category : #accessing }
LowtalkStructureType >> validName [
	^ name ifNil: [#unnamed]
]
