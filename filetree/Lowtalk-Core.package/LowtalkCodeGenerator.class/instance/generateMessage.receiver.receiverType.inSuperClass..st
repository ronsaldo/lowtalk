messages
generateMessage: message receiver: receiver receiverType: receiverType inSuperClass: inSuperClass
	inSuperClass ifFalse: [ 
		message specialMessageType ifNotNil: [ ^ self generateSpecialMessage: message receiver: receiver receiverType: receiverType ].
	].

	^ self generateNormalMessage: message receiver receiver: receiver receiverType: receiverType inSuperClass: inSuperClass