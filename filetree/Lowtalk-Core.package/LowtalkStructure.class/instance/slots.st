accessing
slots
	^ slots ifNil: [slots := slotsExpression value ]