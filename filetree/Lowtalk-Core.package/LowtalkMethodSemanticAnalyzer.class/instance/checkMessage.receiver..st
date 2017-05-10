visiting
checkMessage: message receiver: receiver
	| receiverType |
	(receiver isBlockNode and: [ BlockMessages includes: message selector ]) ifTrue: [ 
		self flag: 'TODO: Support more block special messages'.
		^ self checkWhileLoopMessage: message receiver: receiver
	].

	message compileTimeValue ifNotNil: [ ^ self ].

	receiverType := receiver type withoutReferences.
	receiverType isCompileTimeType ifTrue: [
		^ self evaluateCompileTimeMessage: message receiver: receiver
	].

	message specialMessageType: (receiverType specialMessageTypeForSelector: message selector).
	message specialMessageType ifNotNil: [ ^ self checkSpecialMessage: message messageType: message specialMessageType receiver: receiver ].

	^ self checkNormalMessage: message receiver: receiver