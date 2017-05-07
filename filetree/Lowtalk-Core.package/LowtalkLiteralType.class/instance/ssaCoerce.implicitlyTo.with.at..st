coercions
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	targetType isDynamicObjectType ifTrue: [ 
		self halt.
	].
	
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node