accessing
validTypeValue
	| result |
	result := self type.
	result isValidLowtalkType ifFalse: [ 
		node semanticError: 'expected a valid type.'.
	].
	^ result.