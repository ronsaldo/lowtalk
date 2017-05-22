coercions
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	targetType isIntegerType ifTrue: [ ^ builder intCast: value target: targetType ssaType ].
	targetType isFloatType ifTrue: [ ^ builder intToFloatCast: value target: targetType ssaType ].	
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node