testing
canBeImplicitlyConvertedTo: targetType
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isFloatType ifTrue: [ ^ true ].

	^ false