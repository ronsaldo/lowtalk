testing
canBeExplicitlyConvertedTo: targetType
	targetType isIntegerType ifTrue: [ ^ true ].
	^ super canBeExplicitlyConvertedTo: targetType