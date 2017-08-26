accessing
objectToFloatFunction
	^ objectToFloatFunction ifNil: [
		objectToFloatFunction := compiler objectModel objectToFloatFunction ifNotNil: [:function | compiler ssaValueForObject: function ] ]