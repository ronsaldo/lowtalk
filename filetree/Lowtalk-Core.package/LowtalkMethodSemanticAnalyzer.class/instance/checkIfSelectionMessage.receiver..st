special messages
checkIfSelectionMessage: message receiver: receiver
	| firstResultType secondResultType selector receiverType firstType secondType resultType |
	(self isMessageACandidateForInlining: message receiver: receiver) ifFalse: [
		^ self checkNormalMessage: message receiver: receiver
	].

	self assert: message arguments size >= 1.
	self assert: message arguments size <= 2.
	receiverType := receiver type.
	(receiverType isBooleanType and: [(BooleanControlFlowMessages includes: message selector) not]) ifTrue: [ 
		message semanticError: '{1} cannot be send to boolean value.' format: { message selector printString }
	].

	selector := message selector.
	(#(ifNotNil: ifNotNil:ifNil:) includes: selector) ifTrue: [
		self visitInlinedBlock:  message arguments first cullTypes: { receiverType }.
	].
	self visitInlinedBlock: message arguments first.
	firstType := self extractInlinedBlockType: message arguments first.
	firstResultType := firstType isFunctionType
		ifTrue: [ firstType returnType]
		ifFalse: [ compiler objectType ].
	
	secondResultType := compiler nilType.
	message arguments size = 2 ifTrue: [ 
		secondResultType := compiler objectType.
		(selector == #ifNil:ifNotNil) ifTrue: [ 
			self visitInlinedBlock: message arguments second cullTypes: { receiverType }.
		].
		self visitInlinedBlock: message arguments second.
		secondType := self extractInlinedBlockType: message arguments second.
		secondResultType := secondType isFunctionType
			ifTrue: [ secondType returnType ]
			ifFalse: [ compiler objectType ].
	].
	
	resultType := firstResultType arithmeticCoerceWith: secondResultType.
	resultType ifNil: [ 
		self flag: 'TODO: Maybe try to convert to object?'.
		self halt.
	].
	
	message type: resultType.	