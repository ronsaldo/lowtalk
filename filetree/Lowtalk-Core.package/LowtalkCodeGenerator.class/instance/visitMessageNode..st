visiting
visitMessageNode: message
	| receiver receiverType |
	message compileTimeValue ifNotNil: [ ^ message compileTimeValue ssaValue ].
	message specialMessageType ifNotNil: [
		BlockMessages at: message selector ifPresent: [ :specialType |
			^ self perform: ('generate' , specialType, 'Message:') asSymbol with: message
		]
	].

	receiver := self visitNode: message receiver.
	receiverType := message receiver type.
	^ self generateMessage: message receiver: receiver receiverType: receiverType inSuperClass: message receiver isSuper