special messages
checkUnaryArithmeticMessage: message receiver: receiver
	| receiverValueType |
	receiverValueType := receiver type withoutReferences asValueType.
	receiverValueType isNumberType ifTrue: [
		(message selector == #sqrt and: [ receiverValueType isIntegerType ]) ifTrue: [
			message type: compiler doubleType
		] ifFalse: [ 
			message type: receiverValueType.
		].
		^ self
	].

	^ self checkNormalMessage: message receiver: receiver 