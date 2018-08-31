Class {
	#name : #LowtalkGlobalVariable,
	#superclass : #LowtalkInterpreterVariable,
	#instVars : [
		'definitionEnvironment',
		'ssaValue',
		'isExternal',
		'isVisibleInC',
		'typeExpression',
		'bindingObject',
		'ssaBindingValue'
	],
	#category : #'Lowtalk-Core-Environment'
}

{ #category : #converting }
LowtalkGlobalVariable >> asLowtalkObjectInstanceWith: aCompiler [
	bindingObject ifNotNil: [ ^ bindingObject ].
	
	(self valueType isFunctionType and: [ self isConstant ]) ifTrue: [
		(self ssaValue isExternal and: [ self ssaValue isEmpty ]) ifTrue: [ ^ nil ].
		self ssaValue callingConvention ~~ #smalltalk ifTrue: [ ^ nil ].
		"^ self ssaValue compiledMethodMetaDataValue"
		^ bindingObject := aCompiler objectModel createGlobalVariableAssociationFunction value: self name value: self ssaValue compiledMethodMetaDataValue
	] ifFalse: [
		(self ssaValue isExternal and: [ self ssaValue initialValue isNil ]) ifTrue: [ ^ nil ].
			
		^ self ssaValue headerReferenceOfType: aCompiler objectType
	].
	
]

{ #category : #accessing }
LowtalkGlobalVariable >> buildSSAFunction [
	ssaValue := SLVMFunction module: compiler ssaModule name: self mangledName asSymbol functionType: self valueType ssaType.
	ssaValue gcStrategy: #lowtalk.
	ssaValue unmangledName: self name.

	self isExternal ifTrue: [
		ssaValue makeExternal.
		^ self.
	] ifFalse: [ 
		ssaValue makePublic.
	].

	self value ifNil: [ 
		self error: 'Non external function without definition'.
	].

	compiler compilationTarget emittingDebugInformation ifTrue: [
		ssaValue debugSourceLocation: (compiler convertDebugPosition: self rawValue definition node position).
	].

	compiler mapValue: self rawValue toSSAValue: ssaValue.
	compiler generateFunction: ssaValue value: self rawValue.
	
]

{ #category : #accessing }
LowtalkGlobalVariable >> buildSSAValue [
	ssaValue ifNotNil: [ ^ self ].
	(self valueType isFunctionType and: [ self isConstant ]) ifTrue: [
		self buildSSAFunction.
	] ifFalse: [ 
		self buildSSAVariable.
	].

]

{ #category : #accessing }
LowtalkGlobalVariable >> buildSSAVariable [
	ssaValue := SLVMGlobalVariable module: compiler ssaModule name: self mangledName asSymbol valueType: self valueType ssaType storage: SLVMType genericStorage.
	ssaValue unmangledName: self name.
	
	compiler isSandboxed ifTrue: [ 
		self valueType isAnyDynamicObjectType ifTrue: [ 
			ssaValue customSection: #'.oop'.
			ssaValue headerValue: (compiler ssaModule compilationTarget objectModel
				createObjectVariableHeaderClass: compiler objectModel globalVariableClass name: self name)
		] ifFalse: [ 
			self flag: 'TODO: Support the non-object variables.'
		].
	].
	
	ssaBindingValue ifNotNil: [ 
		ssaValue propertyAt: #binding put: ssaBindingValue
	].
		
	self isExternal ifTrue: [
		ssaValue makeExternal.
	] ifFalse: [ 
		ssaValue makePublic.
	].

	self isConstant ifTrue: [ 
		ssaValue readOnly: true
	].

	self value ifNotNil: [ :actualValue |
		ssaValue initialValue: (compiler translateSSAConstant: actualValue type: self valueType)
	].
]

{ #category : #'as yet unclassified' }
LowtalkGlobalVariable >> compileElement [
	^ self ssaValue

]

{ #category : #accessing }
LowtalkGlobalVariable >> definitionEnvironment [
	^ definitionEnvironment
]

{ #category : #accessing }
LowtalkGlobalVariable >> definitionEnvironment: anObject [
	definitionEnvironment := anObject
]

{ #category : #'code generation' }
LowtalkGlobalVariable >> emitSSAVariableReferenceWith: codeGenerator builder: builder at: node [
	^ self ssaValue
]

{ #category : #accessing }
LowtalkGlobalVariable >> evaluateValueExpression [
	super evaluateValueExpression.
	(self rawValue isNotNil and: [ self valueType isAnyDynamicObjectType ]) ifTrue: [
		compiler registerVariable: self objectInstanceValue: self rawValue.
	].
]

{ #category : #'lazy compilation' }
LowtalkGlobalVariable >> finishCompiling [
	"Nothing required"
]

{ #category : #initialization }
LowtalkGlobalVariable >> initialize [
	super initialize.
	isExternal := false.
	isVisibleInC := false.
	
]

{ #category : #accessing }
LowtalkGlobalVariable >> isExternal [
	^ isExternal
]

{ #category : #accessing }
LowtalkGlobalVariable >> isExternal: anObject [
	isExternal := anObject
]

{ #category : #accessing }
LowtalkGlobalVariable >> isVisibleInC [
	^ isVisibleInC
]

{ #category : #accessing }
LowtalkGlobalVariable >> isVisibleInC: anObject [
	isVisibleInC := anObject
]

{ #category : #accessing }
LowtalkGlobalVariable >> key [
	<compileTime>
	^ name
]

{ #category : #accessing }
LowtalkGlobalVariable >> mangledName [
	isVisibleInC ifTrue: [ ^ name ].
	^ definitionEnvironment mangledName , name size asString , name
]

{ #category : #'as yet unclassified' }
LowtalkGlobalVariable >> prepareToCompile [
	self evaluateValueExpression

]

{ #category : #printing }
LowtalkGlobalVariable >> printOn: aStream [
	aStream nextPutAll: name asString; nextPutAll: ' -> '; print: self rawValue
]

{ #category : #accessing }
LowtalkGlobalVariable >> resolveValueType [
	| result |
	typeExpression ifNotNil: [
		result := typeExpression value.
		(result isFunctionType and: [ self isVisibleInC and: [ result hasSmalltalkConvention ]]) ifTrue: [ 
			result cdecl.
		].
		^ result
	].
	self halt
]

{ #category : #accessing }
LowtalkGlobalVariable >> ssaBindingValue: aBindingValue [
	ssaBindingValue := aBindingValue.
	ssaValue ifNotNil: [
		ssaValue propertyAt: #binding put: ssaBindingValue
	]
]

{ #category : #accessing }
LowtalkGlobalVariable >> ssaValue [
	^ ssaValue ifNil: [ self buildSSAValue . ssaValue]
]

{ #category : #accessing }
LowtalkGlobalVariable >> typeExpression [
	^ typeExpression
]

{ #category : #accessing }
LowtalkGlobalVariable >> typeExpression: anObject [
	typeExpression := anObject
]
