accessing
floatToObjectFunction
	^ floatToObjectFunction ifNil: [
		floatToObjectFunction := compiler objectModel floatToObjectFunction ifNotNil: [:function | compiler ssaValueForObject: function ] ]