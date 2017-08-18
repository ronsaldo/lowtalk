special messages
checkNormalMessage: message receiver: receiver
	"Clear the special message type. This means that the message is dispatched as a normal object message."
	| receiverType |
	message specialMessageType: nil.
	
	receiverType := receiver type withoutReferences.
	
	"Is this an ordinary object message send?"
	(receiverType isDynamicObjectType or: [receiverType canBeImplicitlyConvertedTo: compiler objectType ]) ifTrue: [
		message arguments do: [ :arg |
			self visitNode: arg.
			arg type implicitlyConvertedTo: compiler objectType at: message
		].
	
		message type: compiler objectType.
		^ self
	].
	
	message semanticError: 'Cannot send message {1} to value of type {2}' format: { message selector printString . receiverType name }