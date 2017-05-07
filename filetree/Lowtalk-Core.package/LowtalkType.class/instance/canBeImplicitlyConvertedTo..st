coercions
canBeImplicitlyConvertedTo: targetType
	self = targetType ifTrue: [ ^ true ].
	(targetType isBoxedType and: [ self canBeImplicitlyConvertedTo: targetType boxed ]) ifTrue: [ ^ true ].
	
	^ false