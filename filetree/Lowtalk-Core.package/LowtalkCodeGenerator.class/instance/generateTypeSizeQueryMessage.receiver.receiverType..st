messages
generateTypeSizeQueryMessage: message receiver: receiver receiverType: receiverType
	| queriedType resultValue |
	self assert: message arguments isEmpty.
	
	queriedType := receiverType withoutReferences.
	self assert: queriedType isMetaType.
	queriedType := queriedType instanceType.
	resultValue := queriedType perform: message selector.
	^ message type convertValue: resultValue toSSAConstantWith: compiler