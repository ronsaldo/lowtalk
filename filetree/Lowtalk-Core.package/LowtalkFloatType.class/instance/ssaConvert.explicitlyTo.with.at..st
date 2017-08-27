coercions
ssaConvert: value explicitlyTo: targetType with: builder at: node
	targetType isFloatType ifTrue: [ ^ builder floatingPointCast: value target: targetType ssaType ].	
	targetType isIntegerType ifTrue: [ ^ builder floatToIntCast: value target: targetType ssaType ].
	targetType isDynamicObjectType ifTrue: [ ^ builder floatToDynamicObjectCast: value target: targetType ssaType ].
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node