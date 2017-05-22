testing
canBeImplicitlyConvertedTo: targetType
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isFloatType ifTrue: [ ^ true ].
	(targetType isIntegerType and: [ targetType size >= self size ]) ifTrue: [ ^ true ].
	^ false