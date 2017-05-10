visiting
visitCallExpression: callExpression
	| receiverType |
	callExpression receiver accept: self.
	callExpression arguments do: [ :arg | arg accept: self ].
	
	receiverType := callExpression receiver type withoutReferences.
	receiverType isBlockType ifTrue: [ receiverType := receiverType functionType ].
	
	receiverType isFunctionType ifFalse: [
		"Implemented by sending valueWithArguments:types:"
		callExpression type: compiler objectType.
		^ self.
	].

	self checkCall: receiverType argumentTypes: (callExpression arguments collect: #type) at: callExpression.
	callExpression type: receiverType returnType.
