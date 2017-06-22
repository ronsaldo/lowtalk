special messages
checkComparisonMessage: message receiver: receiver
	| leftType rightType left right coercionType |
	self assert: message arguments size = 1.
	left := receiver.
	leftType := receiver type withoutReferences.
	
	right := message arguments first.
	self visitNode: right.
	
	rightType := message arguments first type withoutReferences.
	
	coercionType := leftType arithmeticCoerceWith: rightType.
	coercionType ifNil: [
		message semanticError: 'Cannot perform comparison operation {1} with values of types "{2}" and "{3}".'
			format:{ message selector printString . leftType name . rightType name }
	].

	
	message
		coercionType: coercionType;
		setTypeIfNil: ((coercionType isDynamicObjectType and: [(#(== ~~) includes:message selector) not])
			ifTrue: [ compiler objectType ] ifFalse: [ compiler booleanType ])