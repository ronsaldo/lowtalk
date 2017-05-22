messages
generateSpecialMessage: message receiver: receiver receiverType: receiverType
	| selector |
	selector := ('generate' , message specialMessageType, 'Message:receiver:receiverType:') asSymbol.
	^ self perform: selector with: message with: receiver with: receiverType