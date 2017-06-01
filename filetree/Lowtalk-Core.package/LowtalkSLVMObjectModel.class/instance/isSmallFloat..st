testing
isSmallFloat: float
	target pointerSize < 8 ifTrue: [ ^ false ].
	self halt