accessing
objectToPointerFunction
	^ objectToPointerFunction ifNil: [
		objectToPointerFunction := compiler objectModel objectToPointerFunction ifNotNil: [:function | compiler ssaValueForObject: function ] ]