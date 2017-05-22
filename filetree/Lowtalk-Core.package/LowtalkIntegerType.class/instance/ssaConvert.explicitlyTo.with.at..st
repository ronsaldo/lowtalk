coercions
ssaConvert: value explicitlyTo: targetType with: builder at: node
	targetType isIntegerType ifTrue: [ ^ builder intCast: value target: targetType ssaType ].
	targetType isFloatType ifTrue: [ ^ builder intToFloatCast: value target: targetType ssaType ].	
	(targetType isPointerType and: [ self size = targetType size ]) ifTrue: [ 
		^ builder bitCast: value target: targetType ssaType
	].	
	
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node