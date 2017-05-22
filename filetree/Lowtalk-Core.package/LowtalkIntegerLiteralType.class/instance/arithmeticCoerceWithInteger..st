coercions
arithmeticCoerceWithInteger: otherType
	otherType size < 4 ifTrue: [ ^ LowtalkTypeInt32 target: compilationTarget  ].
	^ otherType