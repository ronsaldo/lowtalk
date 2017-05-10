special messages
checkSlotMessage: message receiver: receiver
	| receiverType slot |
	receiverType := receiver type withoutReferences.
	slot := receiverType environment lookSymbol: message selector.
	message type: (slot type ref readOnly: receiverType readOnly)