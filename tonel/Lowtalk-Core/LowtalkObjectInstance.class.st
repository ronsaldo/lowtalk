Class {
	#name : #LowtalkObjectInstance,
	#superclass : #LowtalkCompileTimePointer,
	#instVars : [
		'header',
		'slots',
		'compiler'
	],
	#classVars : [
		'ClassPrimitiveSelectors',
		'ObjectPrimitiveSelectors'
	],
	#category : #'Lowtalk-Core-Environment'
}

{ #category : #initialization }
LowtalkObjectInstance class >> initialize [
	ClassPrimitiveSelectors := Dictionary newFromPairs: #(
		basicNew classPrimitive_basicNew
		basicNew: classPrimitive_basicNew:
	).
	
	ObjectPrimitiveSelectors := Dictionary newFromPairs: #(
		basicAt: primitive_basicAt:
		basicAt:put: primitive_basicAt:put:
		basicSize primitive_basicSize
		
		identityHash primitive_identityHash
		class primitive_class
		== primitive_identityEquals:
		~~ primitive_identityNotEquals:
		castTo: primitive_castTo:
		reinterpretCastTo: primitive_reinterpretCastTo:
		yourself primitive_yourself
		__fillAllSlotsWithElementsOf: primitive_fillAllSlotsWithElementsOf:
		__fillAllSlotsWithIntegerElementsOf: primitive_fillAllSlotsWithIntegerElementsOf:
		__fillAllVariableSlotsWithElementsOf: primitive_fillAllVariableSlotsWithElementsOf:
		).
	
]

{ #category : #accessing }
LowtalkObjectInstance >> asClassType [
	^ compiler classTypeForObject: self
]

{ #category : #converting }
LowtalkObjectInstance >> asLowtalkObjectInstanceWith: aCompiler [
	^ self
]

{ #category : #accessing }
LowtalkObjectInstance >> asLowtalkTypeIn: aNode [
	^ compiler classTypeForObject: self
]

{ #category : #accessing }
LowtalkObjectInstance >> behavior [
	^ compiler objectModel getObjectClass: self
]

{ #category : #accessing }
LowtalkObjectInstance >> classBinding [
	^ self asClassType classBinding

]

{ #category : #'class primitives' }
LowtalkObjectInstance >> classPrimitive_basicNew [
	^ self classPrimitive_basicNew: 0

]

{ #category : #'class primitives' }
LowtalkObjectInstance >> classPrimitive_basicNew: size [
	^ self asClassType classPrimitive_basicNew: size
]

{ #category : #accessing }
LowtalkObjectInstance >> compiler [
	^ compiler
]

{ #category : #accessing }
LowtalkObjectInstance >> compiler: anObject [
	compiler := anObject
]

{ #category : #'message dispatching' }
LowtalkObjectInstance >> doLowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler [
	| method |
	(self isRegisteredClass and: [ClassPrimitiveSelectors includesKey: selector]) ifTrue: [
		^ self perform: (ClassPrimitiveSelectors at: selector) withArguments: arguments
	].
	ObjectPrimitiveSelectors at: selector ifPresent: [ :implementation |
		(#(castTo: reinterpretCastTo:) includes: selector) ifTrue: [
			^ self perform: implementation withArguments: (LowtalkLazyValue zipValues: arguments types: argumentTypes node: aCompiler)
		].

		^ self perform: implementation withArguments: arguments
	].

	method := self behavior asClassType lookupSelector: selector.
	method ifNil: [
		self flag: 'TODO: Send doesNotUnderstand:'.
		sendingNode semanticError: 'Unsupported selector {1} ' format: { selector printString }
	].

	^ method lowtalkValueWithArguments: { self } , arguments
		types: {self type} , argumentTypes compiler: aCompiler at: sendingNode
]

{ #category : #'message dispatching' }
LowtalkObjectInstance >> doLowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler [
	| method |
	(self isRegisteredClass and: [ClassPrimitiveSelectors includesKey: selector]) ifTrue: [
		^ self perform: (ClassPrimitiveSelectors at: selector) withArguments: (arguments collect: #value)
	].
	ObjectPrimitiveSelectors at: selector ifPresent: [ :implementation |
		(#(castTo: reinterpretCastTo) includes: selector) ifTrue: [
			^ self perform: implementation withArguments: arguments
		].

		^ self perform: implementation withArguments: (arguments collect: #value)
	].

	method := self behavior asClassType lookupSelector: selector.
	method ifNil: [
		self flag: 'TODO: Send doesNotUnderstand:'.
		sendingNode semanticError: 'Unsupported selector {1} ' format: { selector printString }
	].

	^ method lowtalkValueWithArguments: { self } , (arguments collect: #value)
		types: {self type} , (arguments collect: #type) compiler: aCompiler at: sendingNode
]

{ #category : #accessing }
LowtalkObjectInstance >> header [
	^ header
]

{ #category : #accessing }
LowtalkObjectInstance >> header: anObject [
	header := anObject
]

{ #category : #accessing }
LowtalkObjectInstance >> headerPointer [
	^ LowtalkObjectHeaderPointer new object: self
]

{ #category : #testing }
LowtalkObjectInstance >> isObjectInstance [
	^ true
]

{ #category : #testing }
LowtalkObjectInstance >> isRegisteredClass [
	^ compiler isRegisteredClassObject: self
]

{ #category : #accessing }
LowtalkObjectInstance >> lowtalkLiteralTypeWith: aLowtalkCompiler [
	^ aLowtalkCompiler objectType
]

{ #category : #'message dispatching' }
LowtalkObjectInstance >> lowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler [
	| time result |
	^ aCompiler profilingInterpreter ifFalse: [ 
		self doLowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler
	] ifTrue: [ 
		time := [
			result := self doLowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler
		] timeToRun asMilliSeconds.

		time > 0 ifTrue: [ 
			FileStream stdout nextPutAll: ('{1} timeToRun ms {2}' format: { selector printString . time asString }); lf.
		].
		result
	]

]

{ #category : #'message dispatching' }
LowtalkObjectInstance >> lowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler [
	| time result |
	^ aCompiler profilingInterpreter ifFalse: [ 
		self doLowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
	] ifTrue: [ 
		time := [
			result := self doLowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
		] timeToRun asMilliSeconds.

		time > 0 ifTrue: [ 
			aCompiler log: '{1} timeToRun ms {2}' format: { selector printString . time asString }
		].
		result
	]
]

{ #category : #'as yet unclassified' }
LowtalkObjectInstance >> pointerForSlotDescription: aSlotDescription [
	^ LowtalkSlotPointer new description: aSlotDescription; object: self
]

{ #category : #'object primitives' }
LowtalkObjectInstance >> primitive_basicAt: index [
	| type |
	type := self behavior asClassType.
	^ slots at: type instanceSize + index
]

{ #category : #'object primitives' }
LowtalkObjectInstance >> primitive_basicAt: index put: value [
	| type |
	type := self behavior asClassType.
	^ slots at: type instanceSize + index put: value
]

{ #category : #'object primitives' }
LowtalkObjectInstance >> primitive_basicSize [
	^ slots size
]

{ #category : #'object primitives' }
LowtalkObjectInstance >> primitive_castTo: targetTypeLazyValue [
	| targetType |
	targetType := targetTypeLazyValue value asLowtalkTypeIn: targetTypeLazyValue node.
	^ self type convertValue: self toType: targetType at: targetTypeLazyValue node
]

{ #category : #'object primitives' }
LowtalkObjectInstance >> primitive_class [
	^ self behavior
]

{ #category : #'object primitives' }
LowtalkObjectInstance >> primitive_fillAllSlotsWithElementsOf: aSequence [
	self assert: slots size = aSequence size.
	1 to: slots size do: [ :i | slots at: i put: (aSequence at: i) ].
]

{ #category : #'object primitives' }
LowtalkObjectInstance >> primitive_fillAllSlotsWithIntegerElementsOf: aSequence [
	self assert: slots size = aSequence size.
	1 to: slots size do: [ :i | slots at: i put: (aSequence at: i) asInteger ].
]

{ #category : #'object primitives' }
LowtalkObjectInstance >> primitive_fillAllVariableSlotsWithElementsOf: aSequence [
	| type fixedSize |
	type := self behavior asClassType.
	fixedSize := type instanceSize.
	self assert: slots size = (aSequence size + fixedSize).
	1 to: aSequence size do: [ :i | slots at: fixedSize + i put: (aSequence at: i) ].
]

{ #category : #'object primitives' }
LowtalkObjectInstance >> primitive_identityEquals: other [
	^ self == other
]

{ #category : #'object primitives' }
LowtalkObjectInstance >> primitive_identityNotEquals: other [
	^ self ~~ other
]

{ #category : #'object primitives' }
LowtalkObjectInstance >> primitive_reinterpretCastTo: targetTypeLazyValue [
	| targetType |
	targetType := targetTypeLazyValue value.
	(targetType isPointerType or: [ targetType isAnyDynamicObjectType ]) ifTrue: [ ^ self ].
	targetTypeLazyValue semanticError: 'Cannot reinterpret object of type {1} into type {2}.' format: { self type name . targetType name }
]

{ #category : #'object primitives' }
LowtalkObjectInstance >> primitive_yourself [
	^ self
]

{ #category : #'as yet unclassified' }
LowtalkObjectInstance >> slotType [
	slots class = ByteArray ifTrue: [ ^ compiler byteType ].
	slots class = Array ifTrue: [ ^ compiler objectType ].
	self halt
]

{ #category : #accessing }
LowtalkObjectInstance >> slots [
	^ slots
]

{ #category : #accessing }
LowtalkObjectInstance >> slots: anObject [
	slots := anObject
]

{ #category : #'as yet unclassified' }
LowtalkObjectInstance >> slotsType [
	^ self slotType array: slots size
]

{ #category : #'as yet unclassified' }
LowtalkObjectInstance >> ssaSlotsType [
	^ self slotsType ssaType
]

{ #category : #'as yet unclassified' }
LowtalkObjectInstance >> ssaValueType [
	| headerType slotsType |
	headerType := compiler objectModel headerType ssaType.
	slotsType := self ssaSlotsType.
	^ SLVMStructureType name: #objectInstanceType types: { headerType . slotsType} kind: SLVMStructureType genericKind names: #(header slots)
]

{ #category : #'as yet unclassified' }
LowtalkObjectInstance >> toSSAPointerConstantWith: aCompiler [
	^ aCompiler convertDynamicObjectSSAConstant: self
]

{ #category : #accessing }
LowtalkObjectInstance >> type [
	| behavior |
	behavior := self behavior.
	^ compiler classTypeForObject: behavior
]
