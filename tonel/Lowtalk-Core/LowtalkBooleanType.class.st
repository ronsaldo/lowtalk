Class {
	#name : #LowtalkBooleanType,
	#superclass : #LowtalkPrimitiveType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #coercions }
LowtalkBooleanType >> arithmeticCoerceWithBoolean: another [
	^ self
]

{ #category : #coercions }
LowtalkBooleanType >> arithmeticCoerceWithBooleanLiteral: another [
	^ self
]

{ #category : #accessing }
LowtalkBooleanType >> buildSSAType [
	^ SLVMType boolType
]

{ #category : #coercions }
LowtalkBooleanType >> convertBooleanValue: value toObjectWith: builder at: node [
	| trueBlock falseBlock mergeBlock branch phi |
	trueBlock := builder newBasicBlock: #boolTrueCase.
	falseBlock := builder newBasicBlock: #boolFalseCase.
	mergeBlock := builder newBasicBlock: #boolMergeCase.
		
	branch := builder branch: value ifTrue: trueBlock ifFalse: falseBlock.
	branch mergeBlock: mergeBlock.
		
	builder
		currentBlock: trueBlock;
		jump: mergeBlock;
		currentBlock: falseBlock;
		jump: mergeBlock;
		currentBlock: mergeBlock.
	phi := builder phi: builder dynamicObjectType.
	phi addValue: (builder addDynamicLiteral: true) from: trueBlock.
	phi addValue: (builder addDynamicLiteral: false) from: falseBlock.
	^ phi
]

{ #category : #accessing }
LowtalkBooleanType >> defaultSSAValueWith: builder [
	^ builder constBool: false
]

{ #category : #accessing }
LowtalkBooleanType >> defaultValue [
	^ false
]

{ #category : #coercions }
LowtalkBooleanType >> dispatchArithmeticCoerceWith: otherType [
	^ otherType arithmeticCoerceWithBoolean: self
]

{ #category : #testing }
LowtalkBooleanType >> isBooleanType [
	^ true
]

{ #category : #testing }
LowtalkBooleanType >> name [
	^ #BooleanBit
]

{ #category : #'as yet unclassified' }
LowtalkBooleanType >> operationSignature [
	^ #bool
]

{ #category : #testing }
LowtalkBooleanType >> size [
	^ 1
]

{ #category : #coercions }
LowtalkBooleanType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	targetType isDynamicObjectType ifTrue: [ 
		^ self convertBooleanValue: value toObjectWith: builder at: node
	].

	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node
]

{ #category : #coercions }
LowtalkBooleanType >> ssaConvert: value explicitlyTo: targetType with: builder at: node [
	targetType isDynamicObjectType ifTrue: [ 
		^ self convertBooleanValue: value toObjectWith: builder at: node
	].
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node
]
