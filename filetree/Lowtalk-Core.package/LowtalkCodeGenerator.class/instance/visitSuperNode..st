visiting
visitSuperNode: node
	selfType isVoidType ifTrue: [ ^ nil ].
	^ selfValue