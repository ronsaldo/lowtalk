top level entry points
generateFunctionBody: body
	self visitNode: body.
	
	method hasLocalReturns ifTrue: [
		irBuilder
			pushReceiver
			returnTop.
	] ifFalse: [
		method returnType isVoidType ifTrue: [ 
			irBuilder pushLiteral: nil.
		] ifFalse:[
			self coerceImplicitlyFrom: body type to: method returnType at: method node.
		].
		
		irBuilder returnTop.
	]
