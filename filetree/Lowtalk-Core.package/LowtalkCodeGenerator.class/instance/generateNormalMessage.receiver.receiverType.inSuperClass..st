messages
generateNormalMessage: message receiver: receiver receiverType: receiverType inSuperClass: inSuperClass
	| arguments receiverValue instruction |
	receiverValue := self coerceImplicitly: receiver type: receiverType to: compiler objectType at: message.
	arguments := message arguments collect: [ :arg |
		self coerceImplicitly: (self visitNode: arg) type: arg type to: compiler objectType at: message
	].

	((PerformSelectors includes: message selector) and: [arguments first type isDynamicObjectType]) ifTrue: [
		instruction := builder send: arguments first returnType: message type ssaType receiver: receiverValue arguments: arguments allButFirst.
	] ifFalse: [ 
		instruction := builder send: (builder addDynamicLiteral: message selector) returnType: message type ssaType receiver: receiverValue arguments: arguments.
	].

	inSuperClass ifTrue: [ instruction setSuperSend ].
	^ instruction