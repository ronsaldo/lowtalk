Class {
	#name : #LowtalkAbstractClassType,
	#superclass : #LowtalkSpecificDynamicObjectType,
	#instVars : [
		'name',
		'environment',
		'slots',
		'compiler',
		'pendingMethods',
		'slotsExpression',
		'metaSlotsExpression',
		'superclassExpression',
		'superclass',
		'superclassEvaluated',
		'classObject',
		'category',
		'organization',
		'slotsList',
		'objectSlots',
		'nativeSlots',
		'contentSize',
		'contentAlignment',
		'nativeContentOffset',
		'nativeContentSize',
		'layoutType',
		'nativeSlotStructureType',
		'nativeSlotStructurePointerType',
		'metaSuperclassExpression',
		'metaSuperclassEvaluated',
		'metaSuperclass',
		'subclasses',
		'bindingVariable',
		'methodSignatureDictionary'
	],
	#classVars : [
		'SpecificClassObjectSpecialMessages'
	],
	#category : 'Lowtalk-Core-Types'
}

{ #category : #initialization }
LowtalkAbstractClassType class >> initialize [
	SpecificClassObjectSpecialMessages := Dictionary newFromPairs: #(
		__private PrivateSlots
	)
]

{ #category : #comparing }
LowtalkAbstractClassType >> = other [
	^ self == other
]

{ #category : #accessing }
LowtalkAbstractClassType >> addSubclass: aSubclass [
	(subclasses includes: aSubclass) ifFalse: [
		subclasses := subclasses copyWith: aSubclass
	]

]

{ #category : #slots }
LowtalkAbstractClassType >> applySlotsLayout [
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

]

{ #category : #accessing }
LowtalkAbstractClassType >> binding [
	^ self bindingVariable binding
]

{ #category : #accessing }
LowtalkAbstractClassType >> bindingVariable [
	^ bindingVariable
]

{ #category : #accessing }
LowtalkAbstractClassType >> bindingVariable: aVariable [
	bindingVariable := aVariable.
	(compiler isSandboxed not and: [ classObject isNotNil ]) ifTrue: [ 
		bindingVariable ssaBindingValue: classObject binding
	]
]

{ #category : #slots }
LowtalkAbstractClassType >> buildNativeSlotsStructureType [
	self assert: nativeSlots isNotNil.
	
	nativeSlotStructureType := SLVMStructureType new.
	nativeSlotStructureType name: self validName;
		kind: SLVMStructureType genericKind;
		types: (nativeSlots collect: [:slot | slot type ssaType]);
		names: (nativeSlots collect: #validStructureFieldName).

]

{ #category : #slots }
LowtalkAbstractClassType >> buildSlots [
	self assert: slots isNil.
	slots := Dictionary new.
	slotsList := (slotsExpression value ifNil: #()) collect: [:sl | sl asLowtalkSlotWith: compiler].
	self superclass ifNotNil: [ :sc |
		slotsList := (sc slotsList collect: #copy) , slotsList
	].

	self fillSlotDictionary.
	self applySlotsLayout
]

{ #category : #testing }
LowtalkAbstractClassType >> canBeImplicitlyConvertedTo: targetType [
	targetType isClassType ifTrue: [ 
		^ self isSubclassOf: targetType
	].
	^ super canBeImplicitlyConvertedTo: targetType
]

{ #category : #accessing }
LowtalkAbstractClassType >> category [
	<compileTime>
	^ category
]

{ #category : #accessing }
LowtalkAbstractClassType >> category: anObject [
	<compileTime>
	category := anObject
]

{ #category : #methods }
LowtalkAbstractClassType >> category: categoryName methods: newMethods [
	<compileTime>
	newMethods do: [ :method |
		pendingMethods at: method selector put: method.
		organization at: method put: categoryName
	].

]

{ #category : #testing }
LowtalkAbstractClassType >> classDepth [
	| result position |
	result := 0.
	position := self.
	[ position ] whileNotNil: [
		result := result + 1.
		position := position superclass.
	].
	^ result
]

{ #category : #accessing }
LowtalkAbstractClassType >> classObject [
	<compileTime>
	classObject ifNil: [ self createClassObject ].
	^ classObject
]

{ #category : #accessing }
LowtalkAbstractClassType >> classObject: anObject [
	classObject := anObject
]

{ #category : #accessing }
LowtalkAbstractClassType >> classSlots: slotsLazyValue [
	<compileTime>
	<lazy>
	metaSlotsExpression := slotsLazyValue
]

{ #category : #accessing }
LowtalkAbstractClassType >> classVariableNames: aStringWithClassVariableNames [
	<compileTime>
]

{ #category : #'lazy compilation' }
LowtalkAbstractClassType >> compileElement [
	self concretizeAllPendingMethods.
]

{ #category : #accessing }
LowtalkAbstractClassType >> compiler [
	^ compiler
]

{ #category : #accessing }
LowtalkAbstractClassType >> compiler: anObject [
	compiler := anObject
]

{ #category : #methods }
LowtalkAbstractClassType >> concretizeAllPendingMethods [
	| toConcretize |
	toConcretize := pendingMethods values copy.
	toConcretize do: [ :pending | self concretizeMethod: pending ]
]

{ #category : #methods }
LowtalkAbstractClassType >> concretizeMethod: aMethod [
	| actualMethod |
	pendingMethods at: aMethod selector ifAbsent: [ ^ self ].
	
	methodSignatureDictionary at: aMethod selector ifAbsentPut: [ aMethod methodSignatureForReceiverTypeValue: self ].
	pendingMethods removeKey: aMethod selector.
	actualMethod := aMethod compiledMethodForReceiverTypeValue: self.
	self installMethod: actualMethod category: 	(organization at: aMethod ifAbsent: [ self defaultMethodCategory ]).
]

{ #category : #accessing }
LowtalkAbstractClassType >> contentAlignment [
	self slots.
	^ contentAlignment
]

{ #category : #accessing }
LowtalkAbstractClassType >> contentSize [
	self slots.
	^ contentSize
]

{ #category : #converting }
LowtalkAbstractClassType >> convertValue: value toType: targetType at: sendingNode [
	targetType isClassType ifTrue: [ ^ value ].
	^ super convertValue: value toType: targetType at: sendingNode
]

{ #category : #'as yet unclassified' }
LowtalkAbstractClassType >> createClassObject [
	self subclassResponsibility
]

{ #category : #methods }
LowtalkAbstractClassType >> defaultMethodCategory [
	^ 'as yet unclassified'
]

{ #category : #superclass }
LowtalkAbstractClassType >> defaultSuperclass [
	self subclassResponsibility
]

{ #category : #methods }
LowtalkAbstractClassType >> doGetMethodSignatureForSelector: selector environment: anEnvironment [
	^ methodSignatureDictionary at: selector ifAbsent: [
		pendingMethods at: selector ifPresent: [ :method |
			methodSignatureDictionary at: selector put: (method methodSignatureForReceiverTypeValue: self)
		] ifAbsent: [nil].
	].
]

{ #category : #accessing }
LowtalkAbstractClassType >> environment [
	<compileTime>
	environment ifNil: [ self halt ].
	^ environment
]

{ #category : #accessing }
LowtalkAbstractClassType >> environment: anObject [
	environment := anObject
]

{ #category : #superclass }
LowtalkAbstractClassType >> evaluateMetaSuperclass [
	metaSuperclassExpression ifNil: [ 
		metaSuperclass := self superclass metaClass
	] ifNotNil: [ 
		metaSuperclass := metaSuperclassExpression value.
		metaSuperclass ifNotNil: [ metaSuperclass asLowtalkTypeWith: compiler ]
	].
	metaSuperclassEvaluated := true
	
]

{ #category : #superclass }
LowtalkAbstractClassType >> evaluateSuperclass [
	superclassExpression ifNil: [ 
		superclass := self defaultSuperclass asLowtalkTypeWith: compiler
	] ifNotNil: [ 
		superclass := superclassExpression value.
		superclass ifNotNil: [ superclass asLowtalkTypeWith: compiler ]
	].

	superclassEvaluated := true
	
]

{ #category : #slots }
LowtalkAbstractClassType >> fillSlotDictionary [
	slots := Dictionary new.
	slotsList do: [ :slot |
		slots at: slot name ifPresent: [ 
			slot node semanticError: 'Class {1} slot name {1} is already in use.'
				format: { self validName . slot name printString }
		] ifAbsentPut: [ slot ].
	].
]

{ #category : #'lazy compilation' }
LowtalkAbstractClassType >> finishCompiling [
]

{ #category : #comparing }
LowtalkAbstractClassType >> hash [
	^ self identityHash
]

{ #category : #initialization }
LowtalkAbstractClassType >> initialize [
	super initialize.
	superclassEvaluated := false.
	metaSuperclassEvaluated := false.
	pendingMethods := OrderedDictionary new.
	methodSignatureDictionary := Dictionary new.
	category := 'Uncategorized'.
	organization := IdentityDictionary new.
	subclasses := #().
]

{ #category : #accessing }
LowtalkAbstractClassType >> instanceSize [
	<compileTime>
	^ self objectSlots size
]

{ #category : #testing }
LowtalkAbstractClassType >> isAggregateType [
	^ true
]

{ #category : #testing }
LowtalkAbstractClassType >> isClassType [
	^ true
]

{ #category : #testing }
LowtalkAbstractClassType >> isMetaClass [
	self subclassResponsibility
]

{ #category : #testing }
LowtalkAbstractClassType >> isSubclassOf: anotherType [
	| position |
	position := self.
	self ~~ anotherType ifTrue: [
		self halt
	].

	[ position ] whileNotNil: [
		position == anotherType ifTrue: [ ^ true ].
		position := position superclass.
	].
	^ false
]

{ #category : #accessing }
LowtalkAbstractClassType >> layoutType [
	<compileTime>
	^ layoutType
]

{ #category : #accessing }
LowtalkAbstractClassType >> layoutType: aLayoutType [
	<compileTime>
	^ layoutType := aLayoutType
]

{ #category : #lookup }
LowtalkAbstractClassType >> lookupSelector: selector [
	| result |
	result := self concreteMethodForSelector: selector.
	result ifNotNil: [ ^ result ].
	^ self superclass ifNotNil: [:sc | sc lookupSelector: selector ]
]

{ #category : #'message dispatching' }
LowtalkAbstractClassType >> lowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler [
	selector == #<<< ifTrue: [ ^ compiler classBuilder <<< arguments first ].
	^ super lowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
]

{ #category : #accessing }
LowtalkAbstractClassType >> metaClass [
	"This should return the meta class"
	self subclassResponsibility
]

{ #category : #superclass }
LowtalkAbstractClassType >> metaSuperclass [
	metaSuperclassEvaluated ifFalse: [ self evaluateMetaSuperclass ].
	^ metaSuperclass
]

{ #category : #accessing }
LowtalkAbstractClassType >> metaSuperclass: superClassLazyValue [
	<compileTime>
	<lazy>
	metaSuperclassExpression := superClassLazyValue
]

{ #category : #methods }
LowtalkAbstractClassType >> methodSignatureForSelector: selector environment: anEnvironment [
	| result |
	result := self doGetMethodSignatureForSelector: selector environment: anEnvironment.
	result ifNotNil: [ ^ result ].
	^ self superclass ifNotNil: [ :sc | sc methodSignatureForSelector: selector environment: anEnvironment]
]

{ #category : #methods }
LowtalkAbstractClassType >> methods: newMethods [
	<compileTime>
	self category: self defaultMethodCategory methods: newMethods
]

{ #category : #accessing }
LowtalkAbstractClassType >> name [
	<compileTime>
	^ name
]

{ #category : #accessing }
LowtalkAbstractClassType >> name: anObject [
	name := anObject
]

{ #category : #accessing }
LowtalkAbstractClassType >> nativeContentSize [
	self slots.
	^ nativeContentSize
]

{ #category : #slots }
LowtalkAbstractClassType >> nativeSlotStructurePointerType [
	^ nativeSlotStructurePointerType ifNil: [ nativeSlotStructurePointerType := compilationTarget pointerTo: self nativeSlotStructureType ]
]

{ #category : #slots }
LowtalkAbstractClassType >> nativeSlotStructureType [
	^ nativeSlotStructureType ifNil: [ self buildNativeSlotsStructureType . nativeSlotStructureType ]
]

{ #category : #accessing }
LowtalkAbstractClassType >> nativeSlots [
	nativeSlots ifNil: [ self buildSlots ].
	^ nativeSlots
]

{ #category : #accessing }
LowtalkAbstractClassType >> objectSlots [
	objectSlots ifNil: [ self buildSlots ].
	^ objectSlots
]

{ #category : #accessing }
LowtalkAbstractClassType >> package: anObject [
	<compileTime>
	category := anObject
]

{ #category : #'lazy compilation' }
LowtalkAbstractClassType >> prepareToCompile [
	"Force the creation of the class object"
	self classObject. 
]

{ #category : #accessing }
LowtalkAbstractClassType >> privateSlotsTypeAt: aNode environment: anEnvironment [
	^ (LowtalkObjectSlotsType target: compilationTarget)
		objectType: self;
		accessMode: #__private
]

{ #category : #accessing }
LowtalkAbstractClassType >> privateSlotsTypeIn: anEnvironment at: aNode [
	^ (LowtalkObjectSlotsType target: compilationTarget)
		objectType: self;
		accessMode: #__private
]

{ #category : #accessing }
LowtalkAbstractClassType >> sandbox_class [
	^ self metaClass
]

{ #category : #slots }
LowtalkAbstractClassType >> selectProperLayout [
	self subclassResponsibility
]

{ #category : #slots }
LowtalkAbstractClassType >> slotNamed: slotName [
	^ self slots at: slotName
	
]

{ #category : #slots }
LowtalkAbstractClassType >> slotNamed: slotName ifAbsent: aBlock [
	^ self slots at: slotName ifAbsent: aBlock
	
]

{ #category : #slots }
LowtalkAbstractClassType >> slotNamed: slotName ifPresent: aBlock [
	^ self slots at: slotName ifPresent: aBlock
	
]

{ #category : #accessing }
LowtalkAbstractClassType >> slots [
	slots ifNil: [ self buildSlots ].
	^ slots
]

{ #category : #accessing }
LowtalkAbstractClassType >> slots: slotsLazyValue [
	<compileTime>
	<lazy>
	| baseEnvironment definitionEnvironment |
	slots ifNotNil: [ slotsLazyValue semanticError: 'Cannot redefine the slots of a structure.' ].

	baseEnvironment := slotsLazyValue environment.
	definitionEnvironment := baseEnvironment namespaceEnvironment.

	self
		environment: definitionEnvironment;
		slotsExpression: slotsLazyValue.
]

{ #category : #accessing }
LowtalkAbstractClassType >> slotsExpression [
	^ slotsExpression
]

{ #category : #accessing }
LowtalkAbstractClassType >> slotsExpression: anObject [
	slotsExpression := anObject
]

{ #category : #accessing }
LowtalkAbstractClassType >> slotsList [
	slotsList ifNil: [ self buildSlots ].
	^ slotsList
]

{ #category : #'special messages' }
LowtalkAbstractClassType >> specialMessageTypeForSelector: selector [
	SpecificClassObjectSpecialMessages at: selector ifPresent: [ :type | ^ type ].
	^ super specialMessageTypeForSelector: selector
]

{ #category : #accessing }
LowtalkAbstractClassType >> subclasses [
	<compileTime>
	^ subclasses
]

{ #category : #superclass }
LowtalkAbstractClassType >> superclass [
	<compileTime>
	superclassEvaluated ifFalse: [ self evaluateSuperclass ].
	^ superclass
]

{ #category : #superclass }
LowtalkAbstractClassType >> superclass: superClassLazyValue [
	<compileTime>
	<lazy>
	superclass ifNotNil: [ superClassLazyValue semanticError: 'Cannot change the super class of a class that is already instantiated.' ].

	self
		superclassExpression: superClassLazyValue.
]

{ #category : #superclass }
LowtalkAbstractClassType >> superclassExpression [
	^ superclassExpression
]

{ #category : #superclass }
LowtalkAbstractClassType >> superclassExpression: anObject [
	superclassExpression := anObject
]

{ #category : #accessing }
LowtalkAbstractClassType >> validName [
	^ name ifNil: [#unnamed]
]
