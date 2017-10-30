special messages
checkInvalidMessage: message receiver: receiver
	| valueType specialType |
	"Try again without the reference type."
	receiver type isReferenceType ifTrue: [ 
		valueType := receiver type withoutReferences.
		specialType := valueType specialMessageTypeForSelector: message selector.
		specialType ~~ #Invalid ifTrue: [ 
			message specialMessageType: specialType.
			^ self checkSpecialMessage: message messageType: message specialMessageType receiver: receiver
		]
		
	].

	"This is an error."
	message semanticError: 'Cannot send special message {1} to object of type {2}.' format: { message selector printString . receiver type name }