messages
generateUnaryArithmeticMessage: message receiver: receiver receiverType: receiverType
	| coercedValue |
	message type isDynamicObjectType ifTrue: [
		^ self emitDynamicMessage: message selector receiver: (self coerceImplicitly: receiver type: receiverType to: compiler objectType at: message) arguments: #() at: message
	].

	coercedValue := self coerceImplicitly: receiver type: receiverType to: message type at: message.
	message selector == #negated ifTrue: [
		message type isFloatType ifTrue: [
			^ builder fneg: coercedValue
		] ifFalse: [
			self assert: message type isIntegerType.
			^ builder neg: coercedValue
		]
	].
	message selector == #sqrt ifTrue: [
		self assert: message type isFloatType.
		^ builder fsqrt: coercedValue
	].
	
	self error: 'Unsupported inline unary message.'