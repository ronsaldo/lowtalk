public access
removeReferencesOfValue: value type: aType
	| currentType result |
	self assert: aType isNotNil.
	currentType := aType.
	result := value.
	[ currentType isReferenceType ] whileTrue: [ 
		result := result value.
		currentType := currentType referenced.
	].
	^ result