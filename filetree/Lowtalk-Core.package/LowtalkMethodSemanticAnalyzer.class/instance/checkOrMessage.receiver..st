visiting
checkOrMessage: message receiver: receiver
	| argument blockType blockResultType coercionType |
	self assert: message arguments size = 1.
	argument := message arguments first.
	self visitInlinedBlock: argument types: #() from: message.
	
	blockType := argument type withoutReferences.
	blockResultType := blockType.
	(blockType isFunctionType or: [ blockType isBlockType ]) ifTrue: [ 
		blockResultType := blockType returnType
	].

	coercionType := receiver type arithmeticCoerceWith: blockResultType.
	coercionType ifNil: [ message semanticError: 'Failed to find a proper return type for inlined #or:' ].
	
	message setTypeIfNil: coercionType.