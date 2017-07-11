top level entry points
findCapturedReceiver
	| position |
	method receiverType isVoidType ifFalse: [ ^ nil ].
	position := method parentMethod.
	[position isNotNil] whileTrue: [ 
		position receiverType isVoidType ifFalse: [
			^ {position receiverType . position receiverSSAValue}
		].
		position := position parentMethod
	].
	^ nil