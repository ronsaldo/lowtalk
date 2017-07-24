special messages
checkUncheckedReturnFromFrameValueMessage: message receiver: receiver
	| newFramePointer returnValue newFramePointerType exitPoint exitPointType |
	self assert: message arguments size = 3.
	newFramePointer := message arguments first.
	returnValue := message arguments second.
	exitPoint := message arguments third.
	self visitNode: newFramePointer.
	self visitNode: returnValue.
	self visitNode: exitPoint.
	
	newFramePointerType := newFramePointer type withoutReferences.
	newFramePointerType isPointerType ifFalse: [ 
		message semanticError: 'Expected any pointer value to replace frame pointer thisContext.'
	].

	self flag: 'TODO: Add support for restoring the stack pointer.'.
	
	exitPointType := exitPoint type withoutReferences.
	exitPointType isPointerType ifFalse: [ 
		message semanticError: 'Expected any pointer value for the exit point.'
	].
	
	message type: compiler voidType.