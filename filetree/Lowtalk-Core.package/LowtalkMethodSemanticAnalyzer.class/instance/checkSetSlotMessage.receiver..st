special messages
checkSetSlotMessage: message receiver: receiver
	| receiverType slot valueType |
	self assert: message arguments size = 1.
	receiverType := receiver type withoutReferences.
	slot := receiverType slotNamed: message selector allButLast.
	
	self visitNode: message arguments first.
	valueType := message arguments first type.
	(valueType canBeImplicitlyConvertedTo: slot type) ifFalse: [ 
		message semanticError: 'Cannot convert implicitly a value of type "{1}" to type "{2}"' format: { valueType name . slot type name }
	].
	
	message type: (slot type ref readOnly: receiverType readOnly)