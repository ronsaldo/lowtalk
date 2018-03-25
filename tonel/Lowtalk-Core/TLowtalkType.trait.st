Trait {
	#name : #TLowtalkType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #associating }
TLowtalkType >> , nextType [
	<compileTime>
	^ (LowtalkTypeTuple target: self compilationTarget) types: { self . nextType }
]

{ #category : #associating }
TLowtalkType >> -> returnType [
	<compileTime>
	^ (LowtalkFunctionType target: self compilationTarget)
		arguments: { self };
		returnType: returnType;
		yourself
]

{ #category : #accessing }
TLowtalkType >> alignment [
	self explicitRequirement
]

{ #category : #coercions }
TLowtalkType >> arithmeticCoerceWith: otherType [
	self = otherType ifTrue: [ ^ self ].
	(self isReferenceType or: [ otherType isReferenceType ]) ifTrue: [ ^ self withoutReferences arithmeticCoerceWith: otherType withoutReferences ].
	
	"Always try to convert toward a dynamic object."
	self isDynamicObjectType ifTrue: [ ^ self ].
	otherType isDynamicObjectType ifTrue: [ ^ otherType ].
	
	^ self dispatchArithmeticCoerceWith: otherType
]

{ #category : #coercions }
TLowtalkType >> arithmeticCoerceWithBoolean: otherType [
	^ nil
]

{ #category : #coercions }
TLowtalkType >> arithmeticCoerceWithBooleanLiteral: otherType [
	^ nil
]

{ #category : #coercions }
TLowtalkType >> arithmeticCoerceWithCharacter: otherType [
	^ nil
]

{ #category : #coercions }
TLowtalkType >> arithmeticCoerceWithFloat: otherType [
	^ nil
]

{ #category : #coercions }
TLowtalkType >> arithmeticCoerceWithFloatLiteral: otherType [
	^ nil
]

{ #category : #coercions }
TLowtalkType >> arithmeticCoerceWithInteger: otherType [
	^ nil
]

{ #category : #coercions }
TLowtalkType >> arithmeticCoerceWithIntegerLiteral: otherType [
	^ nil
]

{ #category : #coercions }
TLowtalkType >> arithmeticCoerceWithNilType: nilType [
	^ self
]

{ #category : #coercions }
TLowtalkType >> arithmeticCoerceWithPointer: pointerType [
	^ nil
]

{ #category : #coercions }
TLowtalkType >> arithmeticCoerceWithReference: otherType [
	^ self arithmeticCoerceWith: otherType withoutReferences
]

{ #category : #coercions }
TLowtalkType >> arithmeticCoerceWithStringLiteral: otherType [
	^ nil
]

{ #category : #coercions }
TLowtalkType >> arithmeticCoerceWithSymbolLiteral: otherType [
	^ nil
]

{ #category : #'type composition' }
TLowtalkType >> array [
	<compileTime>
	^ self array: 0
]

{ #category : #'type composition' }
TLowtalkType >> array: elementCount [
	<compileTime>
	^ (LowtalkArrayType target: self compilationTarget)
		baseType: self;
		elements: elementCount;
		yourself
]

{ #category : #converting }
TLowtalkType >> asDefaultReturnTypeWith: aCompiler [
	^ self
]

{ #category : #converting }
TLowtalkType >> asLowtalkTypeIn: aNode [
	^ self
]

{ #category : #converting }
TLowtalkType >> asLowtalkTypeWith: aCompiler [
	^ self
]

{ #category : #accessing }
TLowtalkType >> binding [
	^ nil
]

{ #category : #coercions }
TLowtalkType >> canBeExplicitlyConvertedTo: targetType [
	(self canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	^ false
]

{ #category : #coercions }
TLowtalkType >> canBeImplicitlyConvertedTo: targetType [
	self = targetType ifTrue: [ ^ true ].
	(targetType isBoxedType and: [ self canBeImplicitlyConvertedTo: targetType boxed ]) ifTrue: [ ^ true ].
	
	^ false
]

{ #category : #coercions }
TLowtalkType >> canBeReinterpretedTo: targetType [
	^ false
]

{ #category : #accessing }
TLowtalkType >> classBindingWithCompiler: aCompiler [
	^ nil
]

{ #category : #accessing }
TLowtalkType >> compilationTarget [
	self explicitRequirement
]

{ #category : #methods }
TLowtalkType >> concreteMethodForSelector: selector [
	^ nil
]

{ #category : #'type composition' }
TLowtalkType >> const [
	<compileTime>
	self flag: 'Implement this properly'.
	^ self "copy readOnly: true"
]

{ #category : #coercions }
TLowtalkType >> dispatchArithmeticCoerceWith: otherType [
	^ nil
]

{ #category : #'as yet unclassified' }
TLowtalkType >> evaluateSelfClassTypeInEnvironment: environment at: node [
	node semanticError: 'Cannot evaluate _SelfClassType for a _SelfType of {1}.' format: { self name }
]

{ #category : #'as yet unclassified' }
TLowtalkType >> evaluateSelfInstanceTypeInEnvironment: environment at: node [
	node semanticError: 'Cannot evaluate _SelfInstanceType for a _SelfType of {1}.' format: { self name }
]

{ #category : #'as yet unclassified' }
TLowtalkType >> evaluateSelfTypeInEnvironment: environment at: node [
	^ self
]

{ #category : #coercions }
TLowtalkType >> implicitlyConvertedTo: targetType at: node [
	self flag: 'TODO: Remove this conversion hack.'.
	(targetType isSpecialSelfType and: [ node isSelf or: [ node isSuper ] ]) ifTrue: [ 
		^ self
	].

	(self canBeImplicitlyConvertedTo: targetType) ifFalse: [
		node semanticError: 'Cannot implicitly convert value of type "{1}" to type "{2}"' format: { self name . targetType name }
	]
]

{ #category : #coercions }
TLowtalkType >> irCoerceImplicitlyTo: targetType with: irBuilder at: node [
	self = targetType ifTrue: [ ^ self ].
	self error: 'Unimplemented type coercion conversion.'
]

{ #category : #coercions }
TLowtalkType >> irConvertExplicitlyTo: targetType with: irBuilder at: node [
	self = targetType ifTrue: [ ^ self ].
	self error: 'Unimplemented type coercion conversion.'
]

{ #category : #testing }
TLowtalkType >> isAggregateType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isAnyDynamicObjectType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isArrayType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isBlockType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isBooleanLiteralType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isBooleanType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isBoxedType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isClassType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isCompileTimeType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isDynamicObjectType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isFloatType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isFunctionType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isIntegerType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isLiteralType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isLowtalkType [
	^ true
]

{ #category : #testing }
TLowtalkType >> isMetaType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isNilType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isNumberType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isObjectSlots [
	^ false
]

{ #category : #testing }
TLowtalkType >> isOpaque [
	^ false
]

{ #category : #testing }
TLowtalkType >> isOpaqueType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isPointerType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isPrimitiveType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isReferenceType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isSpecialGenericType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isSpecialSelfType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isSpecificDynamicObjectType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isStructureType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isThisContextType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isTupleType [
	^ false
]

{ #category : #testing }
TLowtalkType >> isValidLowtalkType [
	^ true
]

{ #category : #testing }
TLowtalkType >> isVoidType [
	^ false
]

{ #category : #'type composition' }
TLowtalkType >> metaType [
	<compileTime>
	^ (LowtalkMetaType target: self compilationTarget) instanceType: self
]

{ #category : #methods }
TLowtalkType >> methodSignatureForSelector: selector environment: anEnvironment [
	^ nil
]

{ #category : #'special messages' }
TLowtalkType >> operationSignature [
	self explicitRequirement
]

{ #category : #'type composition' }
TLowtalkType >> pointer [
	<compileTime>
	^ (LowtalkPointerType target: self compilationTarget) pointed: self
]

{ #category : #accessing }
TLowtalkType >> privateSlotsTypeIn: environment at: node [
	node semanticError: 'Cannot access private slots of object of type {1}.' format: { self name }
	
]

{ #category : #'type composition' }
TLowtalkType >> ref [
	<compileTime>
	^ (LowtalkReferenceType target: self compilationTarget) referenced: self
]

{ #category : #accessing }
TLowtalkType >> resultTypeForMetaSelector: selector message: messageNode compiler: compiler evaluator: evaluator [
	(#(size alignment) includes: selector) ifTrue: [ ^ compiler uintPointerType ].
	^ compiler objectType
]

{ #category : #accessing }
TLowtalkType >> size [
	self explicitRequirement
]

{ #category : #slots }
TLowtalkType >> slotNamed: slotName [
	^ self slotNamed: slotName ifAbsent: [ self error: 'Slot not found' ]
	
]

{ #category : #slots }
TLowtalkType >> slotNamed: slotName ifAbsent: aBlock [
	aBlock value
	
]

{ #category : #slots }
TLowtalkType >> slotNamed: slotName ifPresent: aBlock [
	^ nil
	
]

{ #category : #'as yet unclassified' }
TLowtalkType >> solveSpecialTypeWithReceiverNode: receiverNode type: receiverType environment: environment at: node [
	^ self
]

{ #category : #'special messages' }
TLowtalkType >> specialMessageTypeForMetaSelector: selector [
	^ LowtalkTypeSharedPool commonTypeSpecialMessages at: selector ifAbsent: [ nil ]
]

{ #category : #'special messages' }
TLowtalkType >> specialMessageTypeForSelector: selector [
	^ LowtalkTypeSharedPool commonSpecialMessages at: selector ifAbsent: [ nil ]
]

{ #category : #'special messages' }
TLowtalkType >> specialMessageTypeForSelector: selector environment: environment at: node [
	^ self specialMessageTypeForSelector: selector
]

{ #category : #coercions }
TLowtalkType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	self = targetType ifTrue: [ ^ value ].
	self error: 'Unimplemented type coercion conversion.'
]

{ #category : #coercions }
TLowtalkType >> ssaCoerceCVariadic: value with: builder at: node [
	self explicitRequirement
]

{ #category : #coercions }
TLowtalkType >> ssaConvert: value explicitlyTo: targetType with: builder at: node [
	self = targetType ifTrue: [ ^ value ].
	self error: 'Unimplemented type explicit conversion.'
]
