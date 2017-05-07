accessing
ssaValue
	^ ssaValue ifNil: [ self buildSSAValue . ssaValue]