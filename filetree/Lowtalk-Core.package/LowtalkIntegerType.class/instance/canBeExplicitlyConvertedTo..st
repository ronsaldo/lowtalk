converting
canBeExplicitlyConvertedTo: targetType
	(super canBeExplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isIntegerType ifTrue: [ ^ true ].
	targetType isFloatType ifTrue: [ ^ true ].
	(targetType isPointerType and: [ targetType size = self size ]) ifTrue: [ ^ true ].
	^ false