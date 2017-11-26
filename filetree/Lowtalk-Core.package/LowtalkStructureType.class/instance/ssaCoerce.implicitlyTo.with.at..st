accessing
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	targetType isDynamicObjectType ifTrue: [
		^ builder structureToDynamicObjectCast: value target: targetType typeObject: (builder addDynamicLiteral: self)
	].

	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node