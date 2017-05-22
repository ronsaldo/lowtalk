coercions
arithmeticCoerceWithInteger: otherType
	(self size <= 4 and: [otherType size <= 4]) ifTrue: [ 
		"Signed/Unsigned mismatch."
		(self size = 4 and: [ otherType size = 4 ]) ifTrue: [
			^ self isSigned ifTrue: [ self ] ifFalse: [ otherType ]
		].
		^ LowtalkTypeInt32 target: compilationTarget.
	].

	"Increase the size"
	(self size <= 8 and: [ otherType size <= 8 ]) ifTrue: [ 
		^ (self isSigned or: [otherType isSigned]) ifTrue: [ LowtalkTypeInt64 target: compilationTarget  ] ifFalse: [ LowtalkTypeUInt64 target: compilationTarget ]
	].
	

	^ super arithmeticCoerceWithInteger: otherType