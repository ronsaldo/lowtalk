messages
emitArithmetic: selector left: left right: right type: type at: node
	type isLiteralType ifTrue: [ 
		^ left perform: selector with: right
	].

	(type isDynamicObjectType and: [(#(== ~~) includes: selector) not]) ifTrue: [ 
		^ self emitDynamicMessage: selector receiver: left arguments: { right } at: node
	].

	^ builder addOperation: (BinaryOperationMap at: type operationSignature, ' ' , selector) left: left right: right