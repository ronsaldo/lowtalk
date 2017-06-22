messages
generateAtomicSwapValueMessage: message receiver: receiver receiverType: receiverType
	| value valueType variablePointer builtInFunction |
	
	"Fetch the receiver"
	variablePointer := self coerceImplicitly: receiver type: receiverType to: receiverType withoutReferences at: message.

	"Convert the value"
	value := self visitNode: message arguments first.
	valueType := message type.
	value := self coerceImplicitly: value type: message arguments first type to: valueType at: message.
	
	builtInFunction := builder builtInFunctionName: 'atomic.swap_value' argumentTypes: { variablePointer type . valueType ssaType } returnType: valueType ssaType.
	
	^ builder call: builtInFunction arguments: { variablePointer . value }