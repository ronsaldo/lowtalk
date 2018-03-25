Class {
	#name : #LowtalkNamespace,
	#superclass : #LowtalkEnvironment,
	#instVars : [
		'compiler',
		'name',
		'compileTimeOnly',
		'pendingMethods',
		'ssaValue',
		'namespaceObject',
		'methodDict'
	],
	#category : 'Lowtalk-Core-Environment'
}

{ #category : #converting }
LowtalkNamespace >> asLowtalkObjectInstanceWith: aCompiler [
	^ self ssaValue ifNotNil: [:value | value headerReferenceOfType: aCompiler objectType]
]

{ #category : #converting }
LowtalkNamespace >> asLowtalkVariableReferenceFor: aCompiler [
	^ self
]

{ #category : #accessing }
LowtalkNamespace >> associationAt: aName [
	<compileTime>
	^ self lookSymbol: aName
]

{ #category : #accessing }
LowtalkNamespace >> associationAt: aName ifAbsent: aBlock [
	<compileTime>
	^ self lookSymbol: aName ifAbsent: aBlock
]

{ #category : #accessing }
LowtalkNamespace >> at: aSymbol [
	<compileTime>
	^ (self lookSymbol: aSymbol) value
]

{ #category : #'code generation' }
LowtalkNamespace >> buildSSAValue [
	ssaValue ifNotNil: [ ^ self ].
	compiler objectModel namespaceCreationFunction ifNil: [ ^ self ].
	
	ssaValue := SLVMGlobalVariable module: compiler ssaModule name: self mangledName asSymbol valueType: compiler objectType ssaType storage: SLVMType genericStorage.
	ssaValue unmangledName: self name.
	
	ssaValue customSection: #'.oop'.
	ssaValue headerValue: (compiler ssaModule compilationTarget objectModel
			createObjectVariableHeaderClass: compiler objectModel globalVariableClass name: self name).
	ssaValue makePublic.

]

{ #category : #methods }
LowtalkNamespace >> category: categoryName method: method [
	<compileTime>
	pendingMethods at: method selector put: method.

]

{ #category : #methods }
LowtalkNamespace >> category: categoryName methods: methods [
	<compileTime>
	methods do: [ :method | self category: categoryName method: method ]
]

{ #category : #accessing }
LowtalkNamespace >> compilationTarget [
	^ compiler compilationTarget
]

{ #category : #compilation }
LowtalkNamespace >> compileElement [
	self ssaValue
]

{ #category : #accessing }
LowtalkNamespace >> compileTimeOnly [
	^ compileTimeOnly
]

{ #category : #accessing }
LowtalkNamespace >> compileTimeOnly: anObject [
	compileTimeOnly := anObject
]

{ #category : #accessing }
LowtalkNamespace >> compiler [
	^ compiler
]

{ #category : #accessing }
LowtalkNamespace >> compiler: anObject [
	compiler := anObject
]

{ #category : #methods }
LowtalkNamespace >> concreteMethodForSelector: selector [
	pendingMethods at: selector ifPresent: [ :pendingMethod | self concretizeMethod: pendingMethod ].
	^ methodDict at: selector ifAbsent: [ nil ]
]

{ #category : #'as yet unclassified' }
LowtalkNamespace >> concretizeAllPendingMethods [
	pendingMethods values copy do: [ :pending | self concretizeMethod: pending ]
]

{ #category : #accessing }
LowtalkNamespace >> concretizeMethod: aMethod [
	| actualMethod mangledSelector methodPublicSymbol |
	actualMethod := aMethod compiledMethodForReceiverTypeValue: compiler voidType.
	pendingMethods removeKey: aMethod selector.
	
	mangledSelector := self mangleSelector: aMethod selector.
	methodPublicSymbol := self mangledName , mangledSelector size asString , mangledSelector , '_method'.
	actualMethod
		publicSymbol: methodPublicSymbol asSymbol;
		unmangledName: self fullName , '>>' , aMethod selector printString.
	methodDict at: actualMethod selector put: actualMethod
]

{ #category : #'code generation' }
LowtalkNamespace >> dynamicObjectWithBuilder: builder [
	^ builder load: self ssaValue
]

{ #category : #'code generation' }
LowtalkNamespace >> emitSSAVariableCompileTimeValueWith: codeGenerator builder: builder at: node [
	^ self
]

{ #category : #compilation }
LowtalkNamespace >> finishCompiling [
	self namespaceObject
]

{ #category : #accessing }
LowtalkNamespace >> fullName [
	self realParent ifNotNil: [ :realParent |
		realParent realParent ifNil: [ ^ name ].
		^ realParent fullName , '>>' , name
	] ifNil: [
		^ name
	]
]

{ #category : #initialization }
LowtalkNamespace >> initialize [
	super initialize.
	compileTimeOnly := false.
	pendingMethods := Dictionary new.
	methodDict := Dictionary new.
]

{ #category : #testing }
LowtalkNamespace >> isNamespace [
	^ true
]

{ #category : #accessing }
LowtalkNamespace >> key [
	<compileTime>
	^ name
]

{ #category : #accessing }
LowtalkNamespace >> mangledName [
	self realParent ifNotNil: [ :realParent |
		^ realParent mangledName , (name size asString , name)
	] ifNil: [
		^ '_LT'
	]
]

{ #category : #methods }
LowtalkNamespace >> methods: newMethods [
	<compileTime>
	self category: 'uncategorized' methods: newMethods
]

{ #category : #accessing }
LowtalkNamespace >> name [
	^ name
]

{ #category : #accessing }
LowtalkNamespace >> name: anObject [
	name := anObject
]

{ #category : #accessing }
LowtalkNamespace >> namespaceEnvironment [
	^ self
]

{ #category : #compilation }
LowtalkNamespace >> namespaceObject [
	namespaceObject ifNotNil: [ ^ namespaceObject ].
	
	self concretizeAllPendingMethods.
	compiler objectModel namespaceCreationFunction ifNil: [ ^ nil ].
	
	namespaceObject := compiler objectModel namespaceCreationFunction value: name value: symbols values value: methodDict values.
	self ssaValue initialValue: (compiler translateSSAConstant: namespaceObject type: compiler objectType).
	^ namespaceObject
]

{ #category : #compilation }
LowtalkNamespace >> prepareToCompile [
]

{ #category : #accessing }
LowtalkNamespace >> realNamespace [
	^ compileTimeOnly ifTrue: [ nil ] ifFalse: [ self ]
]

{ #category : #accessing }
LowtalkNamespace >> realParent [
	^ parent ifNotNil: [ parent realNamespace ]
]

{ #category : #accessing }
LowtalkNamespace >> receiver [
	^ self
]

{ #category : #accessing }
LowtalkNamespace >> receiverType [
	^ self compiler compileTimeType
]

{ #category : #'code generation' }
LowtalkNamespace >> ssaValue [
	^ ssaValue ifNil: [ self buildSSAValue . ssaValue]
]

{ #category : #accessing }
LowtalkNamespace >> type [
	^ self compiler compileTimeType
]

{ #category : #accessing }
LowtalkNamespace >> variableAt: aSymbol [
	<compileTime>
	^ self lookSymbol: aSymbol
]
