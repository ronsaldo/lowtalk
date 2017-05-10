coercions
arithmeticCoerceWithInteger: otherType
	otherType size < 4 ifTrue: [ self halt.  ].
	^ otherType