coercions
canBeImplicitlyConvertedTo: targetType
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	(targetType isPointerType and: [ targetType pointed isVoidType ]) ifTrue: [ ^ true ].
	targetType isDynamicObjectType ifTrue: [ ^ true ].
	
	^ false