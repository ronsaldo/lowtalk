coercions
canBeExplicitlyConvertedTo: targetType
	(self canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	^ false