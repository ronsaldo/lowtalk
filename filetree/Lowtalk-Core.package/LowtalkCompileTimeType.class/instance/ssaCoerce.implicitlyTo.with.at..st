coercions
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	targetType isDynamicObjectType ifTrue: [
		value isNamespace ifTrue: [
			^ value dynamicObjectWithBuilder: builder
		].
		^ builder addDynamicLiteral: value
	].
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node