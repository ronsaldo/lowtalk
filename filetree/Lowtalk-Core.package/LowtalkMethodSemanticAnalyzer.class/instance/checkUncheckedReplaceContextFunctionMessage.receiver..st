special messages
checkUncheckedReplaceContextFunctionMessage: message receiver: receiver
	| newFunction functionType |
	self assert: message arguments size = 1.
	newFunction := message arguments first.
	self visitNode: newFunction.
	
	functionType := newFunction type withoutReferences.
	functionType isPointerType ifFalse: [ 
		message semanticError: 'Expected any pointer value to replace the function of thisContext.'
	].
	
	message type: compiler voidType.