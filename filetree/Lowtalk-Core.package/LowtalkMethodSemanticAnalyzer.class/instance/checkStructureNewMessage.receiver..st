special messages
checkStructureNewMessage: message receiver: receiver
	| receiverType structureType |
	receiverType := receiver type withoutReferences.
	self assert: receiverType isMetaType.
	
	structureType := receiverType instanceType.
	message type: structureType