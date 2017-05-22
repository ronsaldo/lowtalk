testing
ssaConvert: value explicitlyTo: targetType with: builder at: node
	| pointed |
	"CStrings"
	targetType isPointerType ifTrue: [ 
		pointed := targetType pointed.
		(pointed isIntegerType and: [ pointed size = 1 ]) ifTrue: [
			^ builder constCString: value
		].
	].

	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node