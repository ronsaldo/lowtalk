visiting
visitCallExpression: expression
	| receiver receiverType returnType expectedArgumentTypes arguments result |
	receiver := self evaluateValue: expression receiver.
	receiverType := expression receiver type withoutReferences.
	returnType := compiler objectType.
	(receiverType isFunctionType or: [ receiverType isBlockType ]) ifTrue: [ 
		returnType := receiverType returnType.
		expectedArgumentTypes := receiverType arguments.
	] ifFalse: [
		expectedArgumentTypes expression arguments collect: [ :a | compiler objectType ].
	].

	expression setTypeIfNil: returnType.

	arguments := expression arguments collectWithIndex: [ :arg :index |
		arg type convertValue: (arg accept: self) toType: (expectedArgumentTypes at: index) at: arg 
	].

	^ receiver lowtalkValueWithArguments: arguments types: expectedArgumentTypes compiler: compiler at: expression.