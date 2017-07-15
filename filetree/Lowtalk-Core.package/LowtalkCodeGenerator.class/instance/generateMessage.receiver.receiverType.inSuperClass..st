messages
generateMessage: message receiver: receiver receiverType: receiverType inSuperClass: inSuperClass
	inSuperClass ifFalse: [ 
		message specialMessageType ifNotNil: [ ^ self generateSpecialMessage: message receiver: receiver receiverType: receiverType ].
	].

	message compileTimeMessageLookup ifNotNil: [ ^ self generateMessageWithCompileTimeLookup: message receiver: receiver receiverType: receiverType inSuperClass: inSuperClass ].
	^ self generateNormalMessage: message receiver: receiver receiverType: receiverType inSuperClass: inSuperClass