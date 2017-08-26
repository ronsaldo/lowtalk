messages
generateNotMessage: message receiver: receiver receiverType: receiverType
	message type isDynamicObjectType ifTrue: [
		^ self emitDynamicMessage: message selector receiver: (self coerceImplicitly: receiver type: receiverType to: compiler objectType at: message) arguments: #() at: message
	].

	receiverType isBooleanLiteralType ifTrue: [ 
		^ self coerceImplicitly: receiver not type: receiverType to: message type at: message
	].

	self assert: receiverType isBooleanType.
	^ builder lnot: receiver