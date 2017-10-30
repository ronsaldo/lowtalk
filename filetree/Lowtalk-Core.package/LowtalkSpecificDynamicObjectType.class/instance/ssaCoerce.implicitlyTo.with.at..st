coercions
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	targetType isDynamicObjectType ifTrue: [ ^ value ].
	targetType isSpecialGenericType ifTrue: [ ^ value ].
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node