special messages
checkNormalMessage: message receiver: receiver
	"Clear the special message type. This means that the message is dispatched as a normal object message."
	| receiverType |
	message specialMessageType: nil.
	
	"Is this an ordinary object message send?"
	receiverType := receiver type withoutReferences.
	receiverType isDynamicObjectType ifTrue: [
		message arguments do: [ :arg |
			arg accept: self.
			arg type implicitlyConvertedTo: compiler objectType at: message
		].
	
		message type: compiler objectType.
		^ self
	].
	
	self halt