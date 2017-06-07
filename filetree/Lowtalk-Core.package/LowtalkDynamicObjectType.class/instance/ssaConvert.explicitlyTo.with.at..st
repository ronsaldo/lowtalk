converting
ssaConvert: value explicitlyTo: targetType with: builder at: node
	targetType isBooleanType ifTrue: [ ^ builder dynObjectIdentityNotEquals: value with: (builder addDynamicLiteral: false)].
	targetType isIntegerType ifTrue: [ self halt ].
	targetType isFloatType ifTrue: [ self halt ].
	
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node