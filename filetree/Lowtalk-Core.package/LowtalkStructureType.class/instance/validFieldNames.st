accessing
validFieldNames
	^ fields collectWithIndex: [ :f :i | 'f' , i asString ]