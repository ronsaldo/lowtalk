visiting
visitMessageChainNode: messageChain
	| receiver result superClass |
	receiver := self evaluate: messageChain receiver.
	superClass := messageChain receiver superClassForValue: receiver.
	result := receiver.
	messageChain messages do: [ :message |
		result := self evaluateMessage: message receiver: receiver inSuperclass: superClass
	].

	^ result