visiting
visitCallExpression: callExpression
	| receiver arguments argumentValue expectedType receiverType |
	receiverType := callExpression receiver type withoutReferences.

	(receiverType isFunctionType or:
	[ receiverType isBlockType or:
	[(receiverType isPointerType and: [ receiverType pointed isFunctionType ])]]) ifFalse: [
		self halt.
	].

	"Get the receiver"
	receiver := self visitNode: callExpression receiver.
	receiver := self coerceImplicitly: receiver type: callExpression receiver type to: receiverType at: callExpression.
	(receiver isFunction and: [ receiverType isBlockType ]) ifTrue: [ 
		receiverType := receiverType functionType
	].
	(receiverType isPointerType and: [ receiverType pointed isFunctionType ]) ifTrue: [ 
		receiverType := receiverType pointed
	].
	
	"Get the arguments"
	arguments := callExpression arguments collectWithIndex: [:arg :index |
		argumentValue := self visitNode: arg.
		index <= receiverType arguments size ifTrue: [
			expectedType := receiverType arguments at: index.
			self coerceImplicitly: argumentValue type: arg type to: expectedType at: callExpression
		] ifFalse: [
			self coerceVariadicArgument: argumentValue type: arg type at: callExpression
		]
	].

	"Generate the call"
	receiverType isBlockType ifTrue: [ 
		self halt.
	].
	^ builder call: receiver arguments: arguments