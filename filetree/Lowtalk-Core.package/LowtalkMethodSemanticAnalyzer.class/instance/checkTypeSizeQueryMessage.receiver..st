special messages
checkTypeSizeQueryMessage: message receiver: receiver
	| receiverType |
	receiverType := receiver type withoutReferences.
	self assert: receiverType isMetaType.
	message type: compiler uintPointerType