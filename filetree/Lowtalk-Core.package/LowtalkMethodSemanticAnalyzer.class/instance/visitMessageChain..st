visiting
visitMessageChain: chain
	chain receiver accept: self.
	
	chain messages do: [ :message |
		self checkMessage: message receiver: chain receiver.
		chain type: message type
	].