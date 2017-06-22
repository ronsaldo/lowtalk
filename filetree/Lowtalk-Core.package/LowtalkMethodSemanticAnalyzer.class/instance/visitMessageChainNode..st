visiting
visitMessageChainNode: chain
	self visitNode: chain receiver.
	chain receiver type isStructureType ifTrue: [
		chain receiver type: chain receiver type ref
	].
	
	chain messages do: [ :message |
		self checkMessage: message receiver: chain receiver.
		chain type: message type
	].