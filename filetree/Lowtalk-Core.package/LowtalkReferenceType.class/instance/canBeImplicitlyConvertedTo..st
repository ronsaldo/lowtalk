coercions
canBeImplicitlyConvertedTo: targetType
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^true ].
	(referenced isArrayType and: [ targetType isPointerType and: [ referenced baseType = targetType pointed ] ]) ifTrue: [ ^ true ].
	^ referenced canBeImplicitlyConvertedTo: targetType