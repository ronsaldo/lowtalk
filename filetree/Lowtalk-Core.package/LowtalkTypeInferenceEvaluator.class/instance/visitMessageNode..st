accessing
visitMessageNode: messageNode
	| receiverType |
	receiverType := self evaluate: messageNode receiver.
	self solveMessageType: messageNode withReceiverType: messageNode receiver type.
	^ messageNode type