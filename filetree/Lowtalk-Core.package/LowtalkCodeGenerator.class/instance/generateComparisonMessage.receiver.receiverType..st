messages
generateComparisonMessage: message receiver: receiver receiverType: receiverType
	| leftValue rightValue coercionType leftType rightType |
	leftValue := receiver.
	leftType := receiverType.
	
	rightValue := message arguments first accept: self.
	rightType := message arguments first type.

	coercionType := message coercionType.
	leftValue := self coerceImplicitly: leftValue type: leftType to: coercionType at: message.
	rightValue := self coerceImplicitly: rightValue type: rightType to: coercionType at: message.
	
	^ self emitComparison: message selector left: leftValue right: rightValue type: coercionType at: message