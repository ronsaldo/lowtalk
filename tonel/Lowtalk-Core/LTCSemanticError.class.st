Class {
	#name : #LTCSemanticError,
	#superclass : #LTCError,
	#instVars : [
		'environment',
		'node'
	],
	#category : #'Lowtalk-Core-Exception'
}

{ #category : #accessing }
LTCSemanticError >> description [
	"Return a textual description of the exception."

	^ String streamContents: [ :stream |
		node position ifNotNil: [ :position | position printOn: stream ].
		stream nextPutAll: ': '; nextPutAll: self messageText
	]
]

{ #category : #accessing }
LTCSemanticError >> environment [
	^ environment
]

{ #category : #accessing }
LTCSemanticError >> environment: anObject [
	environment := anObject
]

{ #category : #accessing }
LTCSemanticError >> node [
	^ node
]

{ #category : #accessing }
LTCSemanticError >> node: anObject [
	node := anObject
]
