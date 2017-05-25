special messages
checkWhileLoopMessage: message receiver: receiver
	| conditionBlockType conditionType |
	(self isMessageACandidateForInlining: message receiver: receiver) ifFalse: [
		^ self checkNormalMessage: message receiver: receiver
	].

	self assert: message arguments size <= 1.
	
	message specialMessageType: #WhileLoop.
	self visitInlinedBlock: receiver.

	conditionBlockType := self extractInlinedBlockType: receiver.
	conditionBlockType isFunctionType ifTrue: [
		conditionBlockType arguments ifNotEmpty: [
			message semanticError: '{1} sent to block with arguments.' format: { message selector }.
		]
	] ifFalse: [ 
		^ self checkNormalMessage: message receiver: receiver
	].
	
	conditionType := conditionBlockType returnType withoutReferences.
	(conditionType isBooleanType and: [(BooleanControlFlowMessages includes: message selector) not]) ifTrue: [ 
		message semanticError: '{1} cannot be send to boolean value.' format: { message selector printString }
	].

	message arguments ifNotEmpty: [ 
		self visitInlinedBlock: message arguments first.
	].
	message type: compiler nilType.
