coercions
ssaConvert: value explicitlyTo: targetType with: builder at: node
	targetType isDynamicObjectType ifTrue: [ 
		^ self convertBooleanValue: value toObjectWith: builder at: node
	].
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node