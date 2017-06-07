visiting
visitSelfNode: node
	selfType isVoidType ifTrue: [ ^ nil ].
	^ selfValue