special messages
checkBinaryBitwiseMessage: message receiver: receiver
	self checkArithmeticMessage: message receiver: receiver.
	message type isFloatType ifTrue: [
		message error: 'Cannot perform bitwise logical operation with floating point values.'
	].
