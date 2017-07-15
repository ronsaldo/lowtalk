accessing
receiverType
	environment isNamespace ifTrue: [ ^ environment receiverType ].
	^ super receiverType