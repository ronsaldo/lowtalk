special messages
checkAddressMessage: message receiver: receiver
	| referenceType |
	referenceType := receiver type.
	referenceType isReferenceType ifFalse: [
		message semanticError: 'Expected a reference to extract an address'.
	].

	message type: referenceType withoutReferences pointer.