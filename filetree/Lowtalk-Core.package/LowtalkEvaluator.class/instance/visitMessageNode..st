visiting
visitMessageNode: messageNode
	| receiver superClass |
	receiver := self evaluateValue: messageNode receiver.
	self solveMessageType: messageNode withReceiverType: messageNode receiver type.
	superClass := messageNode receiver superClassForValue: receiver.
	^ self evaluateMessage: messageNode receiver: receiver inSuperclass: superClass