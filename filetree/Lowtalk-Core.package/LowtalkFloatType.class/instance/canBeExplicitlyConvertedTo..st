testing
canBeExplicitlyConvertedTo: targetType
	(super canBeExplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isIntegerType ifTrue: [ ^ true ].
	targetType isFloatType ifTrue: [ ^ true ].
	^ false