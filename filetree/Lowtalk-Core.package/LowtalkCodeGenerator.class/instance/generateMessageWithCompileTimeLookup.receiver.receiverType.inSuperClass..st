messages
generateMessageWithCompileTimeLookup: message receiver: receiver receiverType: receiverType inSuperClass: inSuperClass
	^ self generateNormalMessage: message receiver: receiver receiverType: receiverType inSuperClass: inSuperClass concreteMethod: message compileTimeMessageLookup
