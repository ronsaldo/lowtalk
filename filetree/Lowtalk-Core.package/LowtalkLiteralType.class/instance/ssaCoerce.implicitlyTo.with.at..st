coercions
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	targetType isDynamicObjectType ifTrue: [
		^ builder addDynamicLiteral: value
	].
	
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node