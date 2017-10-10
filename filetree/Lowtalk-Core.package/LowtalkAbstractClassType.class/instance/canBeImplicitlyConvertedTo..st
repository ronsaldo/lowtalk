testing
canBeImplicitlyConvertedTo: targetType
	targetType isClassType ifTrue: [ 
		^ self isSubclassOf: targetType
	].
	^ super canBeImplicitlyConvertedTo: targetType