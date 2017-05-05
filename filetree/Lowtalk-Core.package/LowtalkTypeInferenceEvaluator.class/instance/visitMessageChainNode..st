accessing
visitMessageChainNode: messageChain
	| receiverType resultType |
	receiverType := self evaluate: messageChain receiver.
	resultType := receiverType.
	messageChain messages do: [ :message |
		self solveMessageType: message withReceiverType: receiverType.
	].
	^ resultType