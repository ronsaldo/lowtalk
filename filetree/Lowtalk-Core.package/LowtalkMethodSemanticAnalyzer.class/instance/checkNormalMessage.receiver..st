special messages
checkNormalMessage: message receiver: receiver
	"Clear the special message type. This means that the message is dispatched as a normal object message."
	| receiverType calledMethodSignature passEverythingAsObjects resultType expectedType |
	message specialMessageType: nil.
	
	receiverType := receiver type withoutReferences.
	
	"Visit the arguments".
	message arguments do: [ :arg |
		self visitNode: arg.
	].

	passEverythingAsObjects := receiverType isAnyDynamicObjectType.
	
	"Find a method that implements this message."
	calledMethodSignature := receiverType methodSignatureForSelector: message selector environment: environment.
	calledMethodSignature ifNotNil: [
		
		"This must be a function type."
		calledMethodSignature isFunctionType ifFalse: [ 
			message semanticError: 'Cannot send message {1} to object of type {2}.' format: { message selector printString . receiverType name }
		].
	
		"Check the arguments"
		message arguments doWithIndex: [ :arg :index |
			expectedType := (calledMethodSignature arguments at: index + 1) solveSpecialTypeWithReceiverNode: receiver type: receiverType environment: environment at: arg.
			arg type implicitlyConvertedTo: expectedType at: arg.
			passEverythingAsObjects ifTrue: [
				arg type implicitlyConvertedTo: compiler objectType at: arg
			].
		].
	
		"Use the correct return type."
		resultType := calledMethodSignature returnType solveSpecialTypeWithReceiverNode: receiver type: receiverType environment: environment at: message.

		"If passing everything as an object, then we should be able to cast object -> into the result type."
		(passEverythingAsObjects and: [ resultType isAnyDynamicObjectType not]) ifTrue: [ 
			(compiler objectType canBeExplicitlyConvertedTo: resultType) ifFalse: [ 
				message semanticError: 'Cannot call non-final method with return type of: {1}' format: { resultType asString }
			]
		].

		message type: resultType.
		^ self
	].
	
	"Is this an ordinary object message send?"
	(receiverType isDynamicObjectType or: [receiverType canBeImplicitlyConvertedTo: compiler objectType ]) ifTrue: [
		message arguments do: [ :arg |
			arg type implicitlyConvertedTo: compiler objectType at: arg
		].
	
		message type: compiler objectType.
		^ self
	].
	
	message semanticError: 'Cannot send message {1} to value of type {2}' format: { message selector printString . receiverType name }