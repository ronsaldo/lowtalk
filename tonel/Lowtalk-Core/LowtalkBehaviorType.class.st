Class {
	#name : #LowtalkBehaviorType,
	#superclass : #LowtalkAbstractClassType,
	#instVars : [
		'methodDict',
		'metaClassClass',
		'metaClass',
		'thisClass',
		'classBinding'
	],
	#classVars : [
		'NewObjectForType'
	],
	#category : 'Lowtalk-Core-Types'
}

{ #category : #initialization }
LowtalkBehaviorType class >> initialize [
	NewObjectForType := Dictionary newFromPairs: #(
		pointers newObjectWithPointers:
		variablePointers newObjectWithPointers:
		bytes newObjectWithBytes:
	).
	
]

{ #category : #coercions }
LowtalkBehaviorType >> arithmeticCoerceWithCharacter: anInteger [
	^ LowtalkDynamicObjectType target: compilationTarget
]

{ #category : #converting }
LowtalkBehaviorType >> asLowtalkObjectInstanceWith: aCompiler [
	^ self classObject
]

{ #category : #accessing }
LowtalkBehaviorType >> classBindingWithCompiler: aCompiler [
	^ classBinding ifNil: [classBinding := classObject lowtalkPerform: #binding withArguments: #() types: #() inSuperclass: false node: nil compiler: compiler]
]

{ #category : #'class primitives' }
LowtalkBehaviorType >> classPrimitive_basicNew [
	^ self classPrimitive_basicNew: 0

]

{ #category : #'class primitives' }
LowtalkBehaviorType >> classPrimitive_basicNew: size [
	"TODO: Retrieve the fixed instance size and the format."
	| result resultSize |
	resultSize := self instanceSize + size.
	result := self createRawObjectOfLayoutType: self layoutType size: resultSize.
	compiler objectModel setObject: result class: self classObject.
	^ result
]

{ #category : #methods }
LowtalkBehaviorType >> concreteMethodForSelector: selector [
	pendingMethods at: selector ifPresent: [ :pendingMethod | self concretizeMethod: pendingMethod ].
	^ methodDict at: selector ifAbsent: [ nil ]
]

{ #category : #methods }
LowtalkBehaviorType >> concreteOrPendingMethodForSelector: selector [
	pendingMethods at: selector ifPresent: [ :pendingMethod | ^ pendingMethod ].
	^ methodDict at: selector ifAbsent: [ nil ]
]

{ #category : #'as yet unclassified' }
LowtalkBehaviorType >> createClassObject [
	| metaInstanceSize |
	metaInstanceSize := self metaClass instanceSize.
	classObject := self createRawObjectOfLayoutType: self metaClass layoutType size: metaInstanceSize.
	compiler registerClassType: self for: classObject.
	compiler registerObject: classObject builder: self.
	bindingVariable ifNotNil: [
		compiler registerVariable: bindingVariable objectInstanceValue: classObject
	] ifNil: [ 
		(thisClass isNotNil and: [ thisClass bindingVariable isNotNil and: [ bindingVariable isNil]]) ifTrue: [ 
			compiler registerVariableName: thisClass bindingVariable forMetaClass: classObject
		].
	].

	compiler objectModel setObject: classObject class: self metaClass classObject.
	
	classObject lowtalkPerform: #importDataFromType: withArguments: { self } types: { compiler objectType } inSuperclass: false node: nil compiler: compiler
]

{ #category : #accessing }
LowtalkBehaviorType >> createRawObjectOfLayoutType: aLayoutType size: aSize [
	^ compiler objectModel perform: (NewObjectForType at: aLayoutType) with: aSize
]

{ #category : #superclass }
LowtalkBehaviorType >> defaultSuperclass [
	^ compiler objectModel defaultSuperclass
]

{ #category : #superclass }
LowtalkBehaviorType >> evaluateSuperclass [
	super evaluateSuperclass.
	(superclass isNotNil and: [ self isMetaClass not ]) ifTrue: [
		superclass addSubclass: self
	].
]

{ #category : #compiling }
LowtalkBehaviorType >> finishBuildingObject [
	super compileElement.
	self classObject
		lowtalkPerform: #finishImportDataFromType:
		withArguments: { self } types: { compiler objectType } inSuperclass: false node: nil compiler: compiler.
]

{ #category : #formatting }
LowtalkBehaviorType >> format [
	<compileTime>
	| isize |
	isize := self instanceSize.
	^ compiler objectModel createNamedFormat: self layoutType withInstanceSize: isize
]

{ #category : #slots }
LowtalkBehaviorType >> getClassDescription [
	^ classObject compiler objectModel getClassDescription: classObject
]

{ #category : #'code generation' }
LowtalkBehaviorType >> headerPointer [
	^ self classObject headerPointer
]

{ #category : #initialization }
LowtalkBehaviorType >> initialize [
	super initialize.
	methodDict := IdentityDictionary new.
]

{ #category : #methods }
LowtalkBehaviorType >> installMethod: aMethod category: aCategory [
	methodDict at: aMethod selector put: aMethod
]

{ #category : #accessing }
LowtalkBehaviorType >> instance [
	<compileTime>
	thisClass ifNil: [ self error: 'Finding the instance type of a non-metaclass type.' ].
	^ thisClass
]

{ #category : #accessing }
LowtalkBehaviorType >> instanceOrNil [
	<compileTime>
	^ thisClass
]

{ #category : #formatting }
LowtalkBehaviorType >> instanceSize [
	<compileTime>
	self nativeSlots ifNotEmpty: [ 
		self flag: 'TODO: Add support for mixed objects.'.
		self assert: self objectSlots isEmpty.
		^ self nativeContentSize
	].

	^ self objectSlots size
]

{ #category : #testing }
LowtalkBehaviorType >> isMetaClass [
	^ thisClass isNotNil
]

{ #category : #testing }
LowtalkBehaviorType >> isValueConforming: aValue [
	self flag: 'Check for kindOf:'.
	^ true
]

{ #category : #'message dispatching' }
LowtalkBehaviorType >> lowtalkDispatchSelector: selector arguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler [
	^ self classObject lowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superclass node: sendingNode compiler: aCompiler
]

{ #category : #'message dispatching' }
LowtalkBehaviorType >> lowtalkDispatchSelector: selector lazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler [
	^ self classObject lowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
]

{ #category : #accessing }
LowtalkBehaviorType >> metaClass [
	metaClass ifNotNil: [ ^ metaClass ].
	classObject ifNotNil: [
		^ metaClass := classObject behavior asClassType
	].

	metaClassClass ifNil: [ 
		metaClassClass := self metaSuperclass metaClassClass.
		self assert: metaClassClass isNotNil.
	].

	metaClass := self class target: compilationTarget.
	metaClass
		compiler: compiler;
		name: (name , ' class') asSymbol;
		metaClass: metaClassClass;
		metaClassClass: metaClassClass;
		thisClass: self;
		superclass: self metaSuperclass;
		environment: self environment;
		slotsExpression: metaSlotsExpression.

	compiler addPendingObject: metaClass.
	^ metaClass
]

{ #category : #accessing }
LowtalkBehaviorType >> metaClass: aMetaClass [
	metaClass := aMetaClass
]

{ #category : #accessing }
LowtalkBehaviorType >> metaClassClass [
	<compileTime>
	^ metaClassClass
]

{ #category : #accessing }
LowtalkBehaviorType >> metaClassClass: aBehaviorType [
	<compileTime>
	metaClassClass := aBehaviorType
]

{ #category : #accessing }
LowtalkBehaviorType >> methodDict [
	<compileTime>
	^ methodDict
]

{ #category : #printing }
LowtalkBehaviorType >> printOn: aStream [
	name ifNotNil: [ 
		^ aStream nextPutAll: name
	].
	super printOn: aStream
]

{ #category : #slots }
LowtalkBehaviorType >> selectProperLayout [
	layoutType ifNil: [
		(objectSlots isNotEmpty and: [ nativeSlots isNotEmpty ]) ifTrue: [ 
			self flag: 'TODO: Implement support for mixed pointer and native data.'.
			self error: 'mixed pointer and native slots not yet supported.'
		] ifFalse: [ 
			nativeSlots ifNotEmpty: [
				layoutType := #bytes
			] ifEmpty: [ 
				layoutType := #pointers
			]
		]
	]
]

{ #category : #accessing }
LowtalkBehaviorType >> thisClass [
	^ thisClass
]

{ #category : #accessing }
LowtalkBehaviorType >> thisClass: aClassType [
	thisClass := aClassType
]
