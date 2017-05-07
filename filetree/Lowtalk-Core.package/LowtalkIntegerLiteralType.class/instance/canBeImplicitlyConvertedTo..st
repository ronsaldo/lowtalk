coercions
canBeImplicitlyConvertedTo: targetType
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isIntegerType ifTrue: [ ^ true ].
	targetType isFloatType ifTrue: [ ^ true ].

	^ false