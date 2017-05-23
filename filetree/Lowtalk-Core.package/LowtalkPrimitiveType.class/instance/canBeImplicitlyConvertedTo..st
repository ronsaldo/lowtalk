testing
canBeImplicitlyConvertedTo: targetType
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isDynamicObjectType ifTrue: [ ^ true ].
	^ false