coercions
ssaConvert: value explicitlyTo: targetType with: builder at: node
	targetType isDynamicObjectType ifTrue: [ 
		^ builder addDynamicLiteral: value
	].
	
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node