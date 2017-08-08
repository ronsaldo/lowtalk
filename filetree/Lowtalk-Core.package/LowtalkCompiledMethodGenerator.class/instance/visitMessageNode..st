visiting
visitMessageNode: messageNode
	messageNode compileTimeValue ifNotNil: [ ^ irBuilder pushLiteral: messageNode compileTimeValue ].
	(messageNode receiver isBlockNode and: [ BlockMessages includesKey: messageNode selector ]) ifTrue: [
		^ self compileInlineWhileMessage: messageNode
	].

	self visitNode: messageNode receiver.
	self generateMessage: messageNode receiverType: messageNode receiver type inSuperclass: messageNode receiver isSuper