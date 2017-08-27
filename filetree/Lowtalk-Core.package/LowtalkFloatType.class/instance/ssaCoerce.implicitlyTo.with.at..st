coercions
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	targetType isFloatType ifTrue: [ ^ builder floatingPointCast: value target: targetType ssaType ].	
	targetType isDynamicObjectType ifTrue: [ ^ builder floatToDynamicObjectCast: value target: targetType ssaType ].
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node