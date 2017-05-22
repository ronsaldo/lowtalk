coercions
arithmeticCoerceWithFloat: otherType
	^ self size > otherType size ifTrue: [ self ] ifFalse: [ otherType ]