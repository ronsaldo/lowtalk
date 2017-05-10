slots
buildSlots
	self assert: slots isNil.
	slots := Dictionary new.
	self addSlots: slotsExpression value.