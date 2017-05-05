public access
evaluate: aNode
	aNode type ifNotNil: [ ^ aNode type ].
	^ super evaluate: aNode