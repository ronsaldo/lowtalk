visiting
visitMessageChainNode: messageChain
	| superClass lastMesageIndex |
	self visitNode: messageChain receiver.
	superClass := messageChain receiver isSuper.
	lastMesageIndex := messageChain messages size.
	messageChain messages doWithIndex: [ :message  :index |
		index ~= lastMesageIndex ifTrue: [ irBuilder pushDup ].
		self generateMessage: message receiverType: messageChain receiver type inSuperclass: superClass.
		index ~= lastMesageIndex ifTrue: [ irBuilder popTop ].
	].
