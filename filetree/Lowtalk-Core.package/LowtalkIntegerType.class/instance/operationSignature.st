special messages
operationSignature
	^ self isSigned ifTrue: [ #int ] ifFalse: [ #uint ]