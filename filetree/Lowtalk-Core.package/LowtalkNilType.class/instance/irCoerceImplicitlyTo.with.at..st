coercions
irCoerceImplicitlyTo: targetType with: builder at: node
	targetType isDynamicObjectType ifTrue: [ ^ self ].
	^ super irCoerceImplicitlyTo: targetType with: builder at: node