special messages
checkSpecialMessage: message messageType: specialMessageType receiver: receiver
	| selector |
	selector := ('check' , specialMessageType , 'Message:receiver:') asSymbol.
	^ self perform: selector with: message with: receiver