special messages
extractInlinedBlockType: node
	| type |
	type := node type withoutReferences.
	^ type isBlockType
		ifTrue: [ type functionType ]
		ifFalse: [
			(type isPointerType and: [ type pointed isFunctionType ])
			ifTrue: [ type pointed ] ifFalse: [ type ]
		]