accessing
buildSSAValue
	ssaValue ifNotNil: [ ^ self ].
	(self valueType isFunctionType and: [ self isConstant ]) ifTrue: [
		self buildSSAFunction.
	] ifFalse: [ 
		self buildSSAVariable.
	].
