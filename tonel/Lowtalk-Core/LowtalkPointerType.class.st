Class {
	#name : #LowtalkPointerType,
	#superclass : #LowtalkType,
	#instVars : [
		'pointed',
		'name'
	],
	#classVars : [
		'PointerMessages'
	],
	#category : #'Lowtalk-Core-Types'
}

{ #category : #initialization }
LowtalkPointerType class >> initialize [
	PointerMessages := Dictionary newFromPairs: #(
		at: PointerDeReference
		basicAt: PointerDeReference
		atOffset: PointerDeReference
		basicAtOffset: PointerDeReference

		at:put: PointerElementAssignment
		basicAt:put: PointerElementAssignment
		atOffset:put: PointerElementAssignment
		basicAtOffset:put: PointerElementAssignment

		value PointerDeReference
		value: PointerElementAssignment
		
		fetchAndAdd: AtomicFetchAndAdd
		fetchAndSubtract: AtomicFetchAndAdd
		swapValue: AtomicSwapValue
		
		+ PointerArithmetic
		- PointerArithmetic
	)
]

{ #category : #comparing }
LowtalkPointerType >> = other [
	^ super = other and: [ pointed = other pointed ]
]

{ #category : #testing }
LowtalkPointerType >> alignment [
	^ compilationTarget pointerAlignment
]

{ #category : #accessing }
LowtalkPointerType >> buildSSAType [
	^ compilationTarget pointerTo: pointed ssaType
]

{ #category : #coercions }
LowtalkPointerType >> canBeExplicitlyConvertedTo: targetType [
	(self canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isPointerType ifTrue: [ ^ true ].
	(targetType isIntegerType and: [ targetType size = self size ]) ifTrue: [ ^ true ].
	^ false
]

{ #category : #coercions }
LowtalkPointerType >> canBeImplicitlyConvertedTo: targetType [
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	(targetType isPointerType and: [ targetType pointed isVoidType ]) ifTrue: [ ^ true ].
	targetType isDynamicObjectType ifTrue: [ ^ true ].
	
	^ false
]

{ #category : #testing }
LowtalkPointerType >> canBeReinterpretedTo: targetType [
	^ targetType isPointerType or:
	[ targetType isDynamicObjectType or:
	[ targetType isSpecificDynamicObjectType or:
	[ targetType isIntegerType and: [targetType size = self size ] ] ] ]
]

{ #category : #converting }
LowtalkPointerType >> convertValue: value toSSAConstantWith: compiler [
	value ifNil: [ ^ SLVMConstant type: self ssaType value: 0 ].
	value isInteger ifTrue: [ ^ SLVMConstant type: self ssaType value: value ].
	value isCompileTimePointer ifTrue: [ ^ value toSSAPointerConstantWith: compiler ].
	self halt
]

{ #category : #accessing }
LowtalkPointerType >> defaultSSAValueWith: builder [
	^ SLVMConstant type: self ssaType value: 0
]

{ #category : #accessing }
LowtalkPointerType >> defaultValue [
	^ nil
]

{ #category : #coercions }
LowtalkPointerType >> dispatchArithmeticCoerceWith: otherType [
	^ otherType arithmeticCoerceWithPointer: self
]

{ #category : #comparing }
LowtalkPointerType >> hash [
	^ super hash bitXor: pointed hash.
]

{ #category : #coercions }
LowtalkPointerType >> irCoerceImplicitlyTo: targetType with: irBuilder at: node [
	targetType isDynamicObjectType ifTrue: [ ^ self ].
	^ super irCoerceImplicitlyTo: targetType with: irBuilder at: node
]

{ #category : #testing }
LowtalkPointerType >> isPointerType [
	^ true
]

{ #category : #accessing }
LowtalkPointerType >> name [
	^ name ifNil: [name := pointed name , ' pointer']
]

{ #category : #'as yet unclassified' }
LowtalkPointerType >> operationSignature [
	^ #pointer
]

{ #category : #accessing }
LowtalkPointerType >> pointed [
	^ pointed
]

{ #category : #accessing }
LowtalkPointerType >> pointed: anObject [
	pointed := anObject
]

{ #category : #printing }
LowtalkPointerType >> printOn: aStream [
	aStream print: pointed; nextPutAll: ' pointer'
]

{ #category : #'as yet unclassified' }
LowtalkPointerType >> restrict [
	<compileTime>
	^ self
]

{ #category : #testing }
LowtalkPointerType >> size [
	^ compilationTarget pointerSize
]

{ #category : #'as yet unclassified' }
LowtalkPointerType >> specialMessageTypeForSelector: selector [
	PointerMessages at: selector ifPresent: [:type | ^ type ].
	^ super specialMessageTypeForSelector: selector
]

{ #category : #coercions }
LowtalkPointerType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	(targetType isPointerType and: [ targetType pointed isVoidType ]) ifTrue: [
		^ builder bitCast: value target: targetType ssaType
	].

	targetType isDynamicObjectType ifTrue: [
		^ builder pointerToDynamicObjectCast: value target: targetType ssaType typeObject: (builder addDynamicLiteral: self)
	].
	
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node
]

{ #category : #coercions }
LowtalkPointerType >> ssaCoerceCVariadic: value with: builder at: node [
	^ value
]

{ #category : #coercions }
LowtalkPointerType >> ssaConvert: value explicitlyTo: targetType with: builder at: node [
	(targetType isPointerType or: 
	 [targetType isIntegerType and: [ targetType size = self size ]]) ifTrue: [
		^ builder bitCast: value target: targetType ssaType
	].
	targetType isDynamicObjectType ifTrue: [
		^ builder pointerToDynamicObjectCast: value target: targetType ssaType typeObject: (builder addDynamicLiteral: self)
	].

	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node
]
