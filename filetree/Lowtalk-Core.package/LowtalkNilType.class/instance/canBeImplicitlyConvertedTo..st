testing
canBeImplicitlyConvertedTo: targetType
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isPointerType ifTrue: [ ^ true ].
	targetType isDynamicObjectType ifTrue: [ ^ true ].
	
	^ false