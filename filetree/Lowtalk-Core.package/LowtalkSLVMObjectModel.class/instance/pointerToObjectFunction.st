accessing
pointerToObjectFunction
	^ pointerToObjectFunction ifNil: [
		pointerToObjectFunction := compiler objectModel pointerToObjectFunction ifNotNil: [:function | compiler ssaValueForObject: function ] ]