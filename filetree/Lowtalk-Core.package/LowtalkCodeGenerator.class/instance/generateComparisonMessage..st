messages
generateComparisonMessage: message
	| left leftValue right rightValue coercionType |
	left := message receiver.
	leftValue := left accept: self.
	
	right := message arguments first.
	rightValue := right accept: self.

	coercionType := message coercionType.
	leftValue := self coerceImplicitly: leftValue type: left type to: coercionType at: message.
	rightValue := self coerceImplicitly: rightValue type: right type to: coercionType at: message.
	
	^ self emitComparison: message selector left: leftValue right: rightValue type: coercionType at: message