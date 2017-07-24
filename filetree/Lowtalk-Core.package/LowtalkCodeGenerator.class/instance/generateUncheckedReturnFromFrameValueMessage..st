messages
generateUncheckedReturnFromFrameValueMessage: message
	|  newFramePointerNode newFramePointer returnValueNode returnValue exitPointNode exitPoint builtInFunction |
	self assert: message arguments size = 3.

	newFramePointerNode := message arguments first.
	newFramePointer := self visitNode: newFramePointerNode.
	newFramePointer := self coerceImplicitly: newFramePointer type: newFramePointerNode type to: newFramePointerNode type withoutReferences at: newFramePointerNode.

	returnValueNode := message arguments second.
	returnValue := self visitNode: returnValueNode.
	returnValue := self coerceImplicitly: returnValue type: returnValueNode type to: returnValueNode type withoutReferences at: returnValueNode.

	exitPointNode := message arguments third.
	exitPoint := self visitNode: exitPointNode.
	exitPoint := self coerceImplicitly: exitPoint type: exitPointNode type to: exitPointNode type withoutReferences at: exitPointNode.
	
	builtInFunction := builder builtInFunctionName: 'context.return_from_frame_value'
		argumentTypes: { newFramePointer type . exitPoint type . returnValue type } returnType: compiler voidType ssaType.
	builder
		call: builtInFunction arguments: { newFramePointer . exitPoint . returnValue };
		unreachable