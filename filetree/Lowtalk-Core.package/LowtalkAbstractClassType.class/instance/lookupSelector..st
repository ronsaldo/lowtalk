lookup
lookupSelector: selector
	| result |
	result := self concreteMethodForSelector: selector.
	result ifNotNil: [ ^ result ].
	^ self superclass ifNotNil: [:sc | sc lookupSelector: selector ]