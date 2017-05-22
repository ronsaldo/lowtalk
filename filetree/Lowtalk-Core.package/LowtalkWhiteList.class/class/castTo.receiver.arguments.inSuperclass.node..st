overrides
castTo: selector receiver: receiver arguments: arguments inSuperclass: isInSuperclass node: aNode
	| targetType receiverType |
	self assert: arguments size = 1.
	targetType := arguments first value.
	targetType isLowtalkType ifFalse: [ 
		aNode semanticError: 'Expected a target type for doing the cast.'
	].

	receiverType := receiver lowtalkLiteralTypeWith: arguments first compiler.
	^ receiverType convertValue: receiver toType: targetType at: aNode