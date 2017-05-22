visiting
visitMessageChainNode: chain
	| receiver receiverType result isSuper |
	receiver := chain receiver accept: self.
	receiverType := chain receiver type.
	
	(receiverType isReferenceType and: [ receiverType isStructureType and: [receiver type isPointerType not]]) ifTrue: [ 
		self halt.
	].

	result := receiver.
	isSuper := chain receiver isSuper.
	chain messages do: [ :message |
		result := self generateMessage: message receiver: receiver receiverType: receiverType inSuperClass: isSuper
	].

	^ result