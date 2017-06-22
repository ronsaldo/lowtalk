messages
generateNormalMessage: message receiver: receiver receiverType: receiverType inSuperClass: inSuperClass
	| arguments receiverValue |
	receiverValue := self coerceImplicitly: receiver type: receiverType to: compiler objectType at: message.
	arguments := message arguments collect: [ :arg |
		self coerceImplicitly: (self visitNode: arg) type: arg type to: compiler objectType at: message
	].

	^ builder send: (builder addDynamicLiteral: message selector) returnType: message type ssaType receiver: receiverValue arguments: arguments