Class {
	#name : #LowtalkASTPosition,
	#superclass : #Object,
	#instVars : [
		'collection',
		'start',
		'stop',
		'line',
		'column',
		'endLine',
		'endColumn'
	],
	#category : #'Lowtalk-Core-AST'
}

{ #category : #requirements }
LowtalkASTPosition class >> empty [
	^ self new
]

{ #category : #comparing }
LowtalkASTPosition >> = other [
	^ self class == other class and:
		[ collection  == other collection and:
		[ start = other start and:
		[ stop = other stop ] ] ]
]

{ #category : #converting }
LowtalkASTPosition >> asLowtalkASTPosition [
	^ self
]

{ #category : #accessing }
LowtalkASTPosition >> collection [
	^ collection
]

{ #category : #accessing }
LowtalkASTPosition >> collection: anObject [
	collection := anObject
]

{ #category : #accessing }
LowtalkASTPosition >> column [
	column ifNil: [ self fetchLineAndColumn ].
	^ column
]

{ #category : #accessing }
LowtalkASTPosition >> endColumn [
	endColumn ifNil: [ self fetchEndLineAndColumn ].
	^ endColumn
]

{ #category : #accessing }
LowtalkASTPosition >> endLine [
	endLine ifNil: [ self fetchEndLineAndColumn ].
	^ endLine
]

{ #category : #accessing }
LowtalkASTPosition >> fetchEndLineAndColumn [
	| lineColumn |
	collection ifNil: [
		endLine := 0.
		endColumn := 0.
		^ self
	].

	lineColumn := collection lineColumnAt: stop.
	endLine := lineColumn first.
	endColumn := lineColumn second.
]

{ #category : #accessing }
LowtalkASTPosition >> fetchLineAndColumn [
	| lineColumn |
	collection ifNil: [
		line := 0.
		column := 0.
		^ self
	].

	lineColumn := collection lineColumnAt: start.
	line := lineColumn first.
	column := lineColumn second.
]

{ #category : #accessing }
LowtalkASTPosition >> fileName [
	^ collection ifNil: ['generated'] ifNotNil: [collection name]
]

{ #category : #accessing }
LowtalkASTPosition >> fullPrintOn: aStream [
	
]

{ #category : #comparing }
LowtalkASTPosition >> hash [
	^ self class identityHash bitXor:
		( collection identityHash bitXor: 
		( start hash bitXor: stop hash))
]

{ #category : #accessing }
LowtalkASTPosition >> line [
	line ifNil: [ self fetchLineAndColumn ].
	^ line
]

{ #category : #accessing }
LowtalkASTPosition >> printOn: aStream [
	aStream nextPutAll: self fileName; nextPut: $:; print: self line; nextPut: $:; print: self column 
]

{ #category : #accessing }
LowtalkASTPosition >> sourceCode [
	^ collection copyFrom: start to: stop
]

{ #category : #accessing }
LowtalkASTPosition >> start [
	^ start
]

{ #category : #accessing }
LowtalkASTPosition >> start: anObject [
	start := anObject
]

{ #category : #accessing }
LowtalkASTPosition >> stop [
	^ stop
]

{ #category : #accessing }
LowtalkASTPosition >> stop: anObject [
	stop := anObject
]

{ #category : #'as yet unclassified' }
LowtalkASTPosition >> until: endPosition [
	^ self class new collection: collection; start: start; stop: endPosition stop; yourself
]
