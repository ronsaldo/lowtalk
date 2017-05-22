coercions
ssaConvert: value explicitlyTo: targetType with: builder at: node
	targetType isDynamicObjectType ifTrue: [ 
		self halt.
	].
	
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node