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

	"Check the number of arguments."
	(callExpression arguments size < receiverType arguments size or:
	[callExpression arguments size > receiverType arguments size and: [ receiverType variadic not ]]) ifTrue: [ 
		callExpression semanticError: 'Mismatching number of arguments for function of type {1}.' format: { receiverType name }.
	].

	"Check the type of the argumetns"
	receiverType arguments doWithIndex: [ :expectedType :index |
		(callExpression arguments at: index) type implicitlyConvertedTo: expectedType at: callExpression.
	].

	callExpression type: receiverType returnType.
