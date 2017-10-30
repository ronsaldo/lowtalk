special messages
checkPrivateSlotsMessage: message receiver: receiver
	message type: (receiver type withoutReferences privateSlotsTypeIn: environment at: message)