visiting
visitMessageChainNode: messageChain
	| receiver result superClass |
	receiver := self evaluateValue: messageChain receiver.
	superClass := messageChain receiver superClassForValue: receiver.
	result := receiver.
	messageChain messages do: [ :message |
		self solveMessageType: message withReceiverType: messageChain receiver type.
		result := self evaluateMessage: message receiver: receiver receiverType: messageChain receiver type inSuperclass: superClass.
		messageChain type: message type.
	].

	^ result