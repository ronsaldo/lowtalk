testing
canBeExplicitlyConvertedTo: targetType
	(super canBeExplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isSpecificDynamicObjectType ifTrue: [ ^ true ].
	^ false