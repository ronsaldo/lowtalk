trampoline names
closureInstantiateFunction
	^ closureInstantiateFunction ifNil: [
		closureInstantiateFunction := compiler objectModel closureInstantiateFunction ifNotNil: [:function | compiler ssaValueForObject: function ] ]