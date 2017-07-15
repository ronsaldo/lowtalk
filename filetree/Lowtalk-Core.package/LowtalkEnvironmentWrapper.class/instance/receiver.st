accessing
receiver
	environment isNamespace ifTrue: [ ^ environment receiver ].
	^ super receiver