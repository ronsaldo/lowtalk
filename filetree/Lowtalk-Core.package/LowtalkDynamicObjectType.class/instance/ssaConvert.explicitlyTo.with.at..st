converting
ssaConvert: value explicitlyTo: targetType with: builder at: node
	targetType isBooleanType ifTrue: [ ^ builder dynObjectIdentityNotEquals: value with: (builder addDynamicLiteral: false)].
	targetType isIntegerType ifTrue: [ ^ builder dynamicObjectToIntCast: value target: targetType ssaType ].
	targetType isFloatType ifTrue: [ ^ builder dynamicObjectToFloatCast: value target: targetType ssaType ].
	targetType isSpecificDynamicObjectType ifTrue: [ ^ value ].
	
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node