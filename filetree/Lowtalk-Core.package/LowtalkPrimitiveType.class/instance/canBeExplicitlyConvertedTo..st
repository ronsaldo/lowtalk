testing
canBeExplicitlyConvertedTo: targetType
	(super canBeExplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isDynamicObjectType ifTrue: [ ^ true ].
	^ false