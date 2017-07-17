accessing
nonLocalReturnFunction
	^ nonLocalReturnFunction ifNil: [
		nonLocalReturnFunction := compiler objectModel nonLocalReturnFunction ifNotNil: [:function | compiler ssaValueForObject: function ] ]