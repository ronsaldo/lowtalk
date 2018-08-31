Class {
	#name : #LowtalkInterpreterVariable,
	#superclass : #LowtalkVariable,
	#instVars : [
		'type',
		'valueType',
		'valueExpression',
		'binding'
	],
	#category : #'Lowtalk-Core-Environment'
}

{ #category : #accessing }
LowtalkInterpreterVariable >> binding [
	^ binding ifNil: [ binding := LiteralVariable key: (self name ifNil: #anon) ]
]

{ #category : #accessing }
LowtalkInterpreterVariable >> capturedBinding [
	self valueType isMetaType ifTrue: [
		self value ifNotNil: [ :v | ^ v binding ]
	].
	^ self binding
]

{ #category : #accessing }
LowtalkInterpreterVariable >> evaluateValueExpression [
	valueExpression ifNil: [ ^ self ].
	self value: valueExpression value.
	valueExpression := nil.
	
]

{ #category : #testing }
LowtalkInterpreterVariable >> isInterpreterVariable [
	^ true
]

{ #category : #accessing }
LowtalkInterpreterVariable >> rawValue [
	^ self binding value
]

{ #category : #accessing }
LowtalkInterpreterVariable >> rawValue: aValue [
	^ self binding value: aValue
]

{ #category : #'as yet unclassified' }
LowtalkInterpreterVariable >> resolveType [
	^ self valueType ref.
]

{ #category : #accessing }
LowtalkInterpreterVariable >> resolveValueType [
	self subclassResponsibility
]

{ #category : #accessing }
LowtalkInterpreterVariable >> type [
	^ type ifNil: [ type := self resolveType ]
]

{ #category : #accessing }
LowtalkInterpreterVariable >> value [
	<compileTime>
	valueExpression ifNotNil: [ self evaluateValueExpression ].
	^ self rawValue
]

{ #category : #accessing }
LowtalkInterpreterVariable >> value: anObject [
	valueExpression := nil.
	self rawValue: anObject.
]

{ #category : #accessing }
LowtalkInterpreterVariable >> valueExpression: aValueExpression [
	self rawValue: nil.
	valueExpression := aValueExpression.
]

{ #category : #accessing }
LowtalkInterpreterVariable >> valueType [
	^ valueType ifNil: [ valueType := self resolveValueType ]
]
