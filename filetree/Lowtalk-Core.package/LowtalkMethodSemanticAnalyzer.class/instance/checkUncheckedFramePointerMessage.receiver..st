special messages
checkUncheckedFramePointerMessage: message receiver: receiver
	self assert: message arguments isEmpty.

	message type: compiler voidType pointer.