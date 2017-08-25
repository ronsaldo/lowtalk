coercions
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	targetType isBooleanType ifTrue: [
		^ builder constBool: value
	].
	
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node