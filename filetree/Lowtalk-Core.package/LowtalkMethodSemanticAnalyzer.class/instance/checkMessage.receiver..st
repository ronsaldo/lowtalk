visiting
checkMessage: message receiver: receiver
	| receiverValueType |
	
	(receiver isBlockNode and: [ (BlockMessages includesKey: message selector) and: [self isMessageACandidateForInlining: message receiver: receiver]]) ifTrue: [ 
		self flag: 'TODO: Support more block special messages'.
		^ self checkWhileLoopMessage: message receiver: receiver
	].

	message compileTimeValue ifNotNil: [ ^ self ].
	message compileTimeMessageLookup ifNotNil: [ ^ self checkMessageWithCompileTimeLookup: message receiver: receiver ].

	receiverValueType := receiver type withoutReferences.
	receiverValueType isCompileTimeType ifTrue: [
		^ self evaluateCompileTimeMessage: message receiver: receiver
	].

	message specialMessageType: (receiver type specialMessageTypeForSelector: message selector).
	message specialMessageType ifNil: [ 
		message specialMessageType: (receiverValueType specialMessageTypeForSelector: message selector).
	].

	message specialMessageType ifNotNil: [ ^ self checkSpecialMessage: message messageType: message specialMessageType receiver: receiver ].

	^ self checkNormalMessage: message receiver: receiver