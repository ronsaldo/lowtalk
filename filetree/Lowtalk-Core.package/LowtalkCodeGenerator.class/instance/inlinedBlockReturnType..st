messages
inlinedBlockReturnType: node
	| type |
	type := node type withoutReferences.
	^ type isBlockType ifTrue: [ type functionType returnType ] ifFalse: [ compiler objectType ]