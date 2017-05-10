special messages
checkRangeLoopMessage: message receiver: receiver
	| start increment body end coercionType blockType startType |
	start := message receiver.
	startType := start type withoutReferences.
	message type: startType.
	
	end := message arguments first.
	increment := message arguments size = 3 ifTrue: [ message arguments second ] ifFalse: [ nil ].
	body := message arguments last.
	
	end accept: self.
	coercionType := startType arithmeticCoerceWith: end type.
	coercionType ifNil: [ ^ self checkNormalMessage: message receiver: receiver ].
	
	increment ifNotNil: [
		increment accept: self.
		coercionType := coercionType arithmeticCoerceWith: increment type.
		coercionType ifNil: [ ^ self checkNormalMessage: message receiver: receiver ].
	].

	coercionType := coercionType asValueType.
	self visitInlinedBlock: body types: { coercionType } from: message.
	
	blockType := body type withoutReferences.
	blockType isBlockType ifTrue: [
		blockType := blockType functionType
	].

	blockType isFunctionType ifTrue: [
		(coercionType arithmeticCoerceWith: blockType arguments first) ifNotNil: [ :newCoercionType | coercionType := newCoercionType ].
		coercionType implicitlyConvertedTo: blockType arguments first at: message
	] ifFalse: [ 
		coercionType implicitlyConvertedTo: compiler objectType at: message
	].

	message coercionType: coercionType.