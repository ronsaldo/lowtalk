inline messages
generateMessage: message receiverType: receiverType inSuperclass: inSuperclass
	| inlineSelector |
	message compileTimeValue ifNotNil: [ self halt ].
	message specialMessageType ifNotNil: [ 
		inlineSelector := 'generate' , message specialMessageType , 'Message:receiverType:inSuperclass:'.
		^ self perform: inlineSelector asSymbol withArguments: { message . receiverType . inSuperclass }
	].

	self generateNormalMessage: message receiverType: receiverType inSuperclass: inSuperclass