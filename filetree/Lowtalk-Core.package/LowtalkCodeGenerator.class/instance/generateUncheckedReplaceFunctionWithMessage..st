messages
generateUncheckedReplaceFunctionWithMessage: message
	| newFunction argument builtInFunction |
	self assert: message arguments size = 1.
	argument := message arguments first.
	newFunction := self visitNode: argument.
	newFunction := self coerceImplicitly: newFunction type: argument type to: argument type withoutReferences at: message.
	
	builtInFunction := builder builtInFunctionName: 'context.replace_function' argumentTypes: { newFunction type } returnType: compiler voidType ssaType.
	builder
		call: builtInFunction arguments: { newFunction };
		unreachable