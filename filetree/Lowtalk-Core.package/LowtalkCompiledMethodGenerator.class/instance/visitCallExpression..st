visiting
visitCallExpression: expression
	| receiverType expectedArgumentTypes arguments |
	receiverType := expression receiver type withoutReferences.

	(receiverType isFunctionType or: [ receiverType isBlockType ]) ifTrue: [ 
		expectedArgumentTypes := receiverType arguments.
	] ifFalse: [
		expectedArgumentTypes expression arguments collect: [ :a | compiler objectType ].
	].
	
	"Get the receiver"
	self visitNode: expression receiver.
	self coerceImplicitlyFrom: expression receiver type to: receiverType at: expression.
	
	"Process the arguments"
	arguments := expression arguments.
	arguments doWithIndex: [ :arg :index |
		self visitNode: arg.
		self coerceImplicitlyFrom: arg type to: (expectedArgumentTypes at: index) at: arg.
	].

	irBuilder
		pushConsArray: arguments size;
		pushLiteral: expectedArgumentTypes;
		pushLiteral: compiler;
		pushLiteral: expression;
		send: #lowtalkValueWithArguments:types:compiler:at:
