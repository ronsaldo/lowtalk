accessing
validFieldNames
	^ fields collectWithIndex: [ :f :i |
		i <= fieldNames size ifTrue: [ fieldNames at: i ] ifFalse: [ 'f' , i asString ]
	]