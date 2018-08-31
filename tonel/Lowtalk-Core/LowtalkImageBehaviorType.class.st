Class {
	#name : #LowtalkImageBehaviorType,
	#superclass : #LowtalkAbstractClassType,
	#instVars : [
		'lowtalkMethodDict'
	],
	#classVars : [
		'MethodSignatureSpecs'
	],
	#category : #'Lowtalk-Core-Types'
}

{ #category : #initialization }
LowtalkImageBehaviorType class >> initialize [
	self initializeMethodSignatureSpecs
]

{ #category : #initialization }
LowtalkImageBehaviorType class >> initializeMethodSignatureSpecs [
	MethodSignatureSpecs := IdentityDictionary newFromPairs: { 
		ProtoObject >> #class . '(ProtoObject) -> _SelfClassType'.
		Object >> #yourself . '(Object) -> _SelfType'.
		Behavior >> #basicNew . '(Behavior) -> _SelfInstanceType'.
		Behavior >> #basicNew: . '(Behavior , _DynamicObject) -> _SelfInstanceType'.
		Behavior >> #new . '(Behavior) -> _SelfInstanceType'.
		Behavior >> #new: . '(Behavior , _DynamicObject) -> _SelfInstanceType'.
	}
]

{ #category : #slots }
LowtalkImageBehaviorType >> buildSlots [
	classObject ifNotNil: [ ^ self importSlots ].
	^ super buildSlots
]

{ #category : #accessing }
LowtalkImageBehaviorType >> classBindingWithCompiler: aCompiler [
	^ self classObject binding

]

{ #category : #accessing }
LowtalkImageBehaviorType >> classObject: aClassObject [
	super classObject: aClassObject.
	self name: aClassObject name.
]

{ #category : #methods }
LowtalkImageBehaviorType >> concreteMethodForSelector: aSelector [
	pendingMethods at: aSelector ifPresent: [ :pendingMethod | self concretizeMethod: pendingMethod ].
	^ lowtalkMethodDict ifNotNil: [ lowtalkMethodDict at: aSelector ifAbsent: [ nil ] ]
]

{ #category : #'as yet unclassified' }
LowtalkImageBehaviorType >> convertSlots [
	| myObjectSlots myNativeSlots |
	myObjectSlots := objectSlots.
	myNativeSlots := nativeSlots.
	self superclass ifNotNil: [ :sc |
		myObjectSlots := myObjectSlots allButFirst: sc objectSlots size.
		myNativeSlots := myNativeSlots allButFirst: sc nativeSlots size.
	].
	
	^ (myObjectSlots collect: #asInstanceVariableSlot) ,
	  (myNativeSlots collect: #asSLVMStructureFieldSlot)

]

{ #category : #'as yet unclassified' }
LowtalkImageBehaviorType >> createClassObject [
	| superclassType sc instanceSlots layoutClass |
	self assert: classObject isNil.
	superclassType := self superclass.
	
	"Override the super class for the when having native slots."
	sc := superclassType ifNotNil: [ superclassType classObject ].
	(self nativeSlots isNotEmpty and: [sc == self defaultSuperclass ]) ifTrue: [ sc := SLVMInternalStructure ].
	
	layoutClass := self selectLayoutClassWithSuperclass: sc.
	instanceSlots := self convertSlots.
	
	self compiler clearImageBehaviorNamed: name.
	classObject := compiler classInstaller make: [ :builder |
		name ifNotNil: [
			builder name: name asSymbol
		].
		builder 
			superclass: sc;
			layoutClass: layoutClass;
			slots: instanceSlots;
			sharedVariables: '';
			sharedPools: '';
			category: self category
	].

	bindingVariable ifNotNil: [
		bindingVariable ssaBindingValue: classObject binding
	]

]

{ #category : #superclass }
LowtalkImageBehaviorType >> defaultSuperclass [
	^ Object
]

{ #category : #methods }
LowtalkImageBehaviorType >> doGetMethodSignatureForSelector: selector environment: anEnvironment [
	| result |
	result := super doGetMethodSignatureForSelector: selector environment: anEnvironment.
	(result isNil and: [ classObject isNotNil ]) ifTrue: [
		classObject methodDict at: selector ifPresent: [ :compiledMethod |
			^ self importMethodSignatureFrom: compiledMethod environment: anEnvironment
		]
	].
	^ result
]

{ #category : #methods }
LowtalkImageBehaviorType >> importMethodSignatureFrom: compiledMethod environment: anEnvironment [
	| signature |
	signature := compiledMethod propertyAt: #lowtalkMethodSignature ifAbsent: nil.
	signature ifNil: [
		signature := MethodSignatureSpecs at: compiledMethod ifAbsent: [ nil ].
		signature ifNil: [ ^ nil]
	].

	^ compiler evaluateString: signature
]

{ #category : #'as yet unclassified' }
LowtalkImageBehaviorType >> importSlots [
	slotsList := self classObject allSlots collect: [ :sl | sl asLowtalkSlotWith: compiler ].
	self fillSlotDictionary.
	self applySlotsLayout
]

{ #category : #methods }
LowtalkImageBehaviorType >> installMethod: aMethod category: methodCategory [
	| compiledMethod methodAddition |

	compiledMethod := compiler generateCompiledMethod: aMethod.
	methodAddition := LowtalkMethodAddition new method: compiledMethod;
		behavior: classObject;
		category: methodCategory.

	self compiler addImageMethodAddition: methodAddition.
	methodAddition install.
	self lowtalkMethodDict at: aMethod selector put: aMethod
]

{ #category : #accessing }
LowtalkImageBehaviorType >> instance [
	<compileTime>
	^ classObject baseClass asLowtalkTypeWith: compiler
]

{ #category : #accessing }
LowtalkImageBehaviorType >> instanceOrNil [
	^ self isMetaClass ifTrue: [ classObject baseClass asLowtalkTypeWith: compiler ] ifFalse: [ nil ]
]

{ #category : #testing }
LowtalkImageBehaviorType >> isMetaClass [
	^ classObject isMeta
]

{ #category : #methods }
LowtalkImageBehaviorType >> lowtalkMethodDict [
	^ lowtalkMethodDict ifNil: [ lowtalkMethodDict := IdentityDictionary new ]
]

{ #category : #accessing }
LowtalkImageBehaviorType >> metaClass [
	^ self classObject class asLowtalkTypeWith: compiler
]

{ #category : #'instance creation' }
LowtalkImageBehaviorType >> new [
	self flag: 'Fix this ugly hack.'.
	^ classObject new
]

{ #category : #'as yet unclassified' }
LowtalkImageBehaviorType >> selectLayoutClassWithSuperclass: aSuperclass [
	layoutType ifNotNil: [
		self halt.
	].

	nativeSlots ifNotEmpty: [
		^ SLVMStructureLayout
	].

	^ aSuperclass classLayout class
]

{ #category : #slots }
LowtalkImageBehaviorType >> selectProperLayout [
	(objectSlots isNotEmpty and: [nativeSlots isNotEmpty]) ifTrue: [
		slotsExpression semanticError: 'Cannot mix dynamic object slots and native slots in a single class'.
	]
]

{ #category : #accessing }
LowtalkImageBehaviorType >> superclass [
	"Allow retrieving the super class"
	(superclass isNil and: [classObject isNotNil]) ifTrue: [
		superclass := classObject superclass ifNotNil: [ :sc | sc asLowtalkTypeWith: compiler ].
		superclassEvaluated := true
	].
	^ super superclass
]
