Class {
	#name : #LowtalkType,
	#superclass : #LowtalkBObject,
	#traits : 'TLowtalkType - {#isValidLowtalkType}',
	#classTraits : 'TLowtalkType classTrait',
	#instVars : [
		'ssaType',
		'compilationTarget',
		'readOnly'
	],
	#pools : [
		'LowtalkTypeSharedPool'
	],
	#category : 'Lowtalk-Core-Types'
}

{ #category : #adding }
LowtalkType class >> addStandardTypesToEnvironment: anEnvironment target: aCompilationTarget [
	anEnvironment
		addCompileTimeVariableValue: (LowtalkBooleanType target: aCompilationTarget);
		
		addCompileTimeVariableValue: (LowtalkTypeFloat16 target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkTypeFloat32 target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkTypeFloat64 target: aCompilationTarget);

		addCompileTimeVariableValue: (LowtalkTypeInt8 target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkTypeUInt8 target: aCompilationTarget);

		addCompileTimeVariableValue: (LowtalkTypeInt16 target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkTypeUInt16 target: aCompilationTarget);
		
		addCompileTimeVariableValue: (LowtalkTypeInt32 target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkTypeUInt32 target: aCompilationTarget);

		addCompileTimeVariableValue: (LowtalkTypeInt64 target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkTypeUInt64 target: aCompilationTarget);
		
		addCompileTimeVariableValue: (LowtalkVoidType target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkNilType target: aCompilationTarget);

		addCompileTimeVariableValue: (LowtalkDynamicObjectType target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkThisContextType target: aCompilationTarget);
		
		addCompileTimeVariableValue: (LowtalkBooleanLiteralType target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkCharacterLiteralType target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkFloatLiteralType target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkIntegerLiteralType target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkRationalLiteralType target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkStringLiteralType target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkSymbolLiteralType target: aCompilationTarget);
		
		addCompileTimeVariableValue: (LowtalkSpecialSelfType target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkSpecialSelfInstanceType target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkSpecialSelfClassType target: aCompilationTarget).
		
	aCompilationTarget pointerSize == 4 ifTrue: [ 
		anEnvironment
			setCompileTimeVariable: #IntPointer value: (anEnvironment lookSymbol: #Int32) value;
			setCompileTimeVariable: #UIntPointer value: (anEnvironment lookSymbol: #UInt32) value.
	] ifFalse: [
		anEnvironment
			setCompileTimeVariable: #IntPointer value: (anEnvironment lookSymbol: #Int64) value;
			setCompileTimeVariable: #UIntPointer value: (anEnvironment lookSymbol: #UInt64) value.
	]

]

{ #category : #adding }
LowtalkType class >> target: aCompilationTarget [
	^ self basicNew compilationTarget: aCompilationTarget; initialize; yourself
]

{ #category : #comparing }
LowtalkType >> = other [
	^ (self class == other class) and: [ readOnly = other readOnly ]
]

{ #category : #accessing }
LowtalkType >> alignment [
	self subclassResponsibility
]

{ #category : #converting }
LowtalkType >> asConstantValueType [
	^ self asValueType const
]

{ #category : #converting }
LowtalkType >> asIntegerTypeAt: node [
	node semanticError: 'Expected value with an integer type.'
]

{ #category : #converting }
LowtalkType >> asLowtalkObjectInstanceWith: aCompiler [
	self flag: 'TODO: Implement myself'.
	^ nil
]

{ #category : #accessing }
LowtalkType >> asTypeExpression [
	^ self
]

{ #category : #accessing }
LowtalkType >> asValueType [
	^ self
]

{ #category : #accessing }
LowtalkType >> asValueTypeKeepVoid [
	^ self asValueType
]

{ #category : #accessing }
LowtalkType >> buildSSAType [
	self subclassResponsibility
]

{ #category : #accessing }
LowtalkType >> compilationTarget [
	^ compilationTarget
]

{ #category : #accessing }
LowtalkType >> compilationTarget: anObject [
	compilationTarget := anObject
]

{ #category : #converting }
LowtalkType >> convertLiteralValue: value fromType: sourceType at: aNode [
	self subclassResponsibility
]

{ #category : #converting }
LowtalkType >> convertValue: value toSSAConstantWith: compiler [
	self halt
]

{ #category : #converting }
LowtalkType >> convertValue: value toType: targetType at: sendingNode [
	self = targetType ifTrue: [ ^ value ].
	(self canBeExplicitlyConvertedTo: targetType) ifFalse: [
		sendingNode semanticError: 'Cannot perform implicit conversion from "{1}" to "{2}"' format: { self name . targetType name }
	].
	
	targetType isDynamicObjectType ifTrue: [ ^ value lowtalkConvertToObjectAt: sendingNode ].
	targetType isIntegerType ifTrue: [ ^ targetType truncateLiteralValue: value at: sendingNode ].

	self error: ('Unimplemented type conversion from "{1}" to "{2}"' format: {self name . targetType name })
]

{ #category : #accessing }
LowtalkType >> defaultSSAValueWith: builder [
	self subclassResponsibility
]

{ #category : #accessing }
LowtalkType >> defaultValue [
	self subclassResponsibility
]

{ #category : #comparing }
LowtalkType >> hash [
	^ self class identityHash bitXor: readOnly hash
]

{ #category : #'as yet unclassified' }
LowtalkType >> inferLowtalkTypeWith: aCompiler [
	^ self metaType 
]

{ #category : #initialization }
LowtalkType >> initialize [
	super initialize.
	compilationTarget ifNil: [ self error: 'Missing compilation target' ].
	readOnly := false.
	
]

{ #category : #'as yet unclassified' }
LowtalkType >> lowtalkInferTypeForNodeType: aCompiler [
	^ self metaType 
]

{ #category : #'message dispatching' }
LowtalkType >> lowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler [
	selector == #class ifTrue: [ ^ self sandbox_class ].
	^ super lowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler
]

{ #category : #'message dispatching' }
LowtalkType >> lowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler [
	selector == #class ifTrue: [ ^ self sandbox_class ].
	^ super lowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
]

{ #category : #methods }
LowtalkType >> methodSignatureForMetaSelector: selector environment: anEnvironment [
	^ nil
]

{ #category : #accessing }
LowtalkType >> name [
	^ self asString
]

{ #category : #accessing }
LowtalkType >> readOnly [
	^ readOnly
]

{ #category : #accessing }
LowtalkType >> readOnly: anObject [
	readOnly := anObject
]

{ #category : #accessing }
LowtalkType >> resultTypeForSelector: selector message: messageNode compiler: compiler evaluator: evaluator [
	(#(yourself) includes: selector) ifTrue: [ self ].
	(#(castTo: reinterpretCastTo:) includes: selector) ifTrue: [ ^ evaluator solveTypeExpression: messageNode arguments first ].
	self flag: 'Try to deduce a better result type'.
	^ compiler objectType
]

{ #category : #'message dispatching' }
LowtalkType >> sandbox_class [
	^ self metaType
]

{ #category : #accessing }
LowtalkType >> size [
	self subclassResponsibility
]

{ #category : #accessing }
LowtalkType >> slot [
	^ LowtalkSlot new type: self
]

{ #category : #accessing }
LowtalkType >> ssaType [
	^ ssaType ifNil: [ssaType := self buildSSAType ]
]

{ #category : #accessing }
LowtalkType >> withoutReferences [
	^ self
]
