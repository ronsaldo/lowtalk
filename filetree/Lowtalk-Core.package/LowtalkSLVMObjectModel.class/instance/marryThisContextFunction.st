accessing
marryThisContextFunction
	^ marryThisContextFunction ifNil: [
		marryThisContextFunction := compiler objectModel marryThisContextFunction ifNotNil: [:function | compiler ssaValueForObject: function ] ]