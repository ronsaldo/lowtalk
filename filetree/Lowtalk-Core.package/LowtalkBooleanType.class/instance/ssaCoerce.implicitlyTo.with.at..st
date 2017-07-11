coercions
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	targetType isDynamicObjectType ifTrue: [ 
		^ self convertBooleanValue: value toObjectWith: builder at: node
	].

	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node