messages
generateArithmeticMessage: message receiver: receiver receiverType: receiverType
	| leftValue rightValue coercionType leftType rightType |
	leftType := receiverType.
	leftValue := receiver.
	
	rightType := message arguments first type.
	rightValue := message arguments first accept: self.

	coercionType := message coercionType.
	leftValue := self coerceImplicitly: leftValue type: leftType to: coercionType at: message.
	rightValue := self coerceImplicitly: rightValue type: rightType to: coercionType at: message.
	
	^ self emitArithmetic: message selector left: leftValue right: rightValue type: coercionType at: message