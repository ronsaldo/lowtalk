messages
emitArithmetic: selector left: left right: right type: type at: node
	type isDynamicObjectType ifTrue: [ 
		^ self emitDynamicMessage: selector arguments: { left . right } at: node
	].

	^ builder addOperation: (BinaryOperationMap at: type operationSignature, ' ' , selector) left: left right: right