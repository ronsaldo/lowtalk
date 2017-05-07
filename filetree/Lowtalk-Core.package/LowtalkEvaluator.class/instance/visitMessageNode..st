visiting
visitMessageNode: messageNode
	| receiver superClass |
	messageNode compileTimeValue ifNotNil: [ ^ messageNode compileTimeValue ].
	
	receiver := self evaluateValue: messageNode receiver.
	self solveMessageType: messageNode withReceiverType: messageNode receiver type.
	superClass := messageNode receiver superClassForValue: receiver.
	^ self evaluateMessage: messageNode receiver: receiver receiverType: messageNode receiver type inSuperclass: superClass