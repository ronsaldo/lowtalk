visiting
checkMessage: message receiver: receiver
	| receiverType |
	message compileTimeValue ifNotNil: [ ^ self ].

	receiverType := receiver type.
	receiverType isCompileTimeType ifTrue: [
		^ self evaluateCompileTimeMessage: message receiver: receiver
	].

	self halt.