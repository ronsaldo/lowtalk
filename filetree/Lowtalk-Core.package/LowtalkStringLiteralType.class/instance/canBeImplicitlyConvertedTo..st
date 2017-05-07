testing
canBeImplicitlyConvertedTo: targetType
	| pointed |
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	
	"CStrings"
	targetType isPointerType ifTrue: [ 
		pointed := targetType pointed.
		(pointed isIntegerType and: [ pointed size = 1 ]) ifTrue: [ ^ true ].
	].

	^ false