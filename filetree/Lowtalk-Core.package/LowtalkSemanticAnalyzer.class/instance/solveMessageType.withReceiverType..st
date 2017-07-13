visiting
solveMessageType: messageNode withReceiverType: receiverType
	| actualReceiverType |
	messageNode type ifNotNil: [ ^ self ].
	actualReceiverType := receiverType withoutReferences.
	messageNode type: (actualReceiverType resultTypeForSelector: messageNode selector message: messageNode compiler: self compiler evaluator: self)