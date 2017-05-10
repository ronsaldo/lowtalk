coercions
canBeImplicitlyConvertedTo: targetType
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^true ].
	^ referenced canBeImplicitlyConvertedTo: targetType