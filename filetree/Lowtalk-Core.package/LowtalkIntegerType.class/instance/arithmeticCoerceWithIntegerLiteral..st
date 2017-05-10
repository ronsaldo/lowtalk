coercions
arithmeticCoerceWithIntegerLiteral: otherType
	self flag: 'Avoid creating new objects.'.
	^ self size <= 4 ifTrue: [ 
		self isSigned ifTrue: [ LowtalkTypeInt32 target: compilationTarget ] ifFalse: [ LowtalkTypeUInt32 target: compilationTarget ]
	] ifFalse: [ 
		self isSigned ifTrue: [ LowtalkTypeInt64 target: compilationTarget ] ifFalse: [ LowtalkTypeUInt64 target: compilationTarget ]
	].