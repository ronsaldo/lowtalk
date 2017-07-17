accessing
widowThisContextFunction
	^ widowThisContextFunction ifNil: [
		widowThisContextFunction := compiler objectModel widowThisContextFunction ifNotNil: [:function | compiler ssaValueForObject: function ] ]