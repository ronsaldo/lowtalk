visiting
visitMessageNode: message
	| receiver receiverType |
	message compileTimeValue ifNotNil: [ ^ message compileTimeValue ssaValue ].
	message specialMessageType ifNotNil: [
		BlockMessages at: message selector ifPresent: [ :specialType |
			^ self perform: ('generate' , specialType, 'message:') asSymbol with: message
		]
	].

	receiver := message receiver accept: self.
	receiverType := message receiver type.
	^ self generateMessage: message receiver: receiver receiverType: receiverType inSuperClass: message receiver isSuper