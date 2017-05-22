visiting
visitCallExpression: callExpression
	| receiver arguments argumentValue expectedType receiverType |
	receiverType := callExpression receiver type withoutReferences.
	receiverType isBlockType ifTrue: [ receiverType := receiverType functionType ].

	receiverType isFunctionType ifFalse: [
		self halt.
	].

	"Get the receiver"
	receiver := callExpression receiver accept: self.
	receiver := self coerceImplicitly: receiver type: callExpression receiver type to: receiverType at: callExpression.
	
	"Get the arguments"
	arguments := callExpression arguments collectWithIndex: [:arg :index |
		argumentValue := arg accept: self.
		index <= receiverType arguments size ifTrue: [
			expectedType := receiverType arguments at: index.
			self coerceImplicitly: argumentValue type: arg type to: expectedType at: callExpression
		] ifFalse: [
			self coerceVariadicArgument: argumentValue type: arg type at: callExpression
		]
	].

	"Generate the call"
	^ builder call: receiver arguments: arguments