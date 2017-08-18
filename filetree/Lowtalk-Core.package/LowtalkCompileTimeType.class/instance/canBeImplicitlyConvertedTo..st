testing
canBeImplicitlyConvertedTo: targetType
	targetType isDynamicObjectType ifTrue: [ ^ true ].
	^ super canBeImplicitlyConvertedTo: targetType