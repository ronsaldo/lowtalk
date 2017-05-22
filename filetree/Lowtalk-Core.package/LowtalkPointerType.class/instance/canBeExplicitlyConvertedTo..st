coercions
canBeExplicitlyConvertedTo: targetType
	(self canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isPointerType ifTrue: [ ^ true ].
	(targetType isIntegerType and: [ targetType size = self size ]) ifTrue: [ ^ true ].
	^ false