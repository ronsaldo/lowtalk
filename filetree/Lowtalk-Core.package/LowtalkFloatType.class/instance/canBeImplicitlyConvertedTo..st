testing
canBeImplicitlyConvertedTo: targetType
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	(targetType isFloatType and: [targetType size > self size]) ifTrue: [ ^ true ].
	^ false