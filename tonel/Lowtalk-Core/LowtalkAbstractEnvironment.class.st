Class {
	#name : #LowtalkAbstractEnvironment,
	#superclass : #LowtalkBObject,
	#instVars : [
		'parent'
	],
	#category : 'Lowtalk-Core-Environment'
}

{ #category : #requirements }
LowtalkAbstractEnvironment class >> empty [
	^ self new
]

{ #category : #accessing }
LowtalkAbstractEnvironment class >> parent: aParentEnvironment [
	^ self new parent: aParentEnvironment
]

{ #category : #'accessing method dictionary' }
LowtalkAbstractEnvironment >> >> aSymbol [
	<compileTime>
	^ self lookSymbol: aSymbol ifAbsent: [ self error: 'Trying to access undefined symbol ' , aSymbol printString ]
]

{ #category : #accessing }
LowtalkAbstractEnvironment >> addCompileTimeVariableValue: value [
	self setCompileTimeVariable: value name value: value
]

{ #category : #accessing }
LowtalkAbstractEnvironment >> compiler [
	^ parent compiler
]

{ #category : #testing }
LowtalkAbstractEnvironment >> isEnvironment [
	^ true
]

{ #category : #testing }
LowtalkAbstractEnvironment >> isNamespace [
	^ false
]

{ #category : #accessing }
LowtalkAbstractEnvironment >> lookSymbol: symbol [
	self subclassResponsibility
]

{ #category : #accessing }
LowtalkAbstractEnvironment >> lookSymbol: symbol ifAbsent: aBlock [
	self subclassResponsibility
]

{ #category : #accessing }
LowtalkAbstractEnvironment >> lookSymbol: symbol ifAbsentPut: aBlock [
	self subclassResponsibility
]

{ #category : #accessing }
LowtalkAbstractEnvironment >> lookSymbol: symbol ifPresent: aBlock [
	self subclassResponsibility
]

{ #category : #initialization }
LowtalkAbstractEnvironment >> lookSymbolRecursively: symbol ifAbsent: aBlock [
	self lookSymbol: symbol ifPresent: [ :value | ^ value ].
	^ parent ifNil: [ aBlock value ] ifNotNil: [ parent lookSymbolRecursively: symbol ifAbsent: aBlock ]
]

{ #category : #accessing }
LowtalkAbstractEnvironment >> namespaceEnvironment [
	self subclassResponsibility
]

{ #category : #accessing }
LowtalkAbstractEnvironment >> parent [
	^ parent
]

{ #category : #accessing }
LowtalkAbstractEnvironment >> parent: aParent [
	parent := aParent.
	
	self assert: self isNamespace ==> [ aParent isNamespace ].
	
]

{ #category : #accessing }
LowtalkAbstractEnvironment >> receiver [
	parent ifNil: [ self error: 'No receiver available.' ].
	^ parent receiver
]

{ #category : #accessing }
LowtalkAbstractEnvironment >> receiverType [
	parent ifNil: [ self error: 'No receiver available.' ].
	^ parent receiverType
]

{ #category : #accessing }
LowtalkAbstractEnvironment >> receiverTypeOr: defaultType [
	^ parent ifNotNil: [parent receiverTypeOr: defaultType ] ifNil: [defaultType]
]

{ #category : #accessing }
LowtalkAbstractEnvironment >> setCompileTimeVariable: name value: newValue [
	self setSymbol: name
		value: (LowtalkCompileTimeVariable new
			name: name;
			value: newValue;
			compiler: self compiler;
			yourself)
		ifPresent: [ self error: 'already present' ].
]

{ #category : #accessing }
LowtalkAbstractEnvironment >> setSymbol: aSymbol value: aValue [
	self subclassResponsibility
]

{ #category : #accessing }
LowtalkAbstractEnvironment >> setSymbol: aSymbol value: aValue ifPresent: aBlock [
	self subclassResponsibility
]
