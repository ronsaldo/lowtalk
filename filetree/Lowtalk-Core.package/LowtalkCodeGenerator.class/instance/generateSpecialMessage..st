messages
generateSpecialMessage: message
	| selector |
	selector := ('generate' , message specialMessageType, 'Message:') asSymbol.
	^ self perform: selector with: message