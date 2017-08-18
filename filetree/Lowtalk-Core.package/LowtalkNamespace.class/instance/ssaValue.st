code generation
ssaValue
	^ ssaValue ifNil: [ self buildSSAValue . ssaValue]