messages
generateAtomicFetchAndAddMessage: message receiver: receiver receiverType: receiverType
	| value valueType variablePointer builtInName builtInFunction |
	
	"Fetch the receiver"
	variablePointer := self coerceImplicitly: receiver type: receiverType to: receiverType withoutReferences at: message.

	"Convert the value"
	value := message arguments first accept: self.
	valueType := message type.
	value := self coerceImplicitly: value type: message arguments first type to: valueType at: message.
	
	builtInName := message selector = #fetchAndAdd: ifTrue: [ 'atomic.fetch_and_add' ] ifFalse: [ 'atomic.fetch_and_subtract' ].
	builtInFunction := builder builtInFunctionName: builtInName argumentTypes: { variablePointer type . valueType ssaType } returnType: valueType ssaType.
	
	^ builder call: builtInFunction arguments: { variablePointer . value }