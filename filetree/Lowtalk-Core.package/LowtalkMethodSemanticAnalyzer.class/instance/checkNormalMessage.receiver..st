special messages
checkNormalMessage: message receiver: receiver
	"Clear the special message type. This means that the message is dispatched as a normal object message."
	message specialMessageType: nil.
	
	self halt