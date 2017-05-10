as yet unclassified
operationSignature
	^ self isSigned ifTrue: [ #int ] ifFalse: [ #uint ]