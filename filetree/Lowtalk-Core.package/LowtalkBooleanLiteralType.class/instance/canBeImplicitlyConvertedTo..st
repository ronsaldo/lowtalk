coercions
canBeImplicitlyConvertedTo: targetType
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isBooleanType ifTrue: [ ^ true ].

	^ false