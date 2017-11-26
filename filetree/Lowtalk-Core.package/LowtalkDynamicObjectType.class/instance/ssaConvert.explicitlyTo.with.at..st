converting
ssaConvert: value explicitlyTo: targetType with: builder at: node
	targetType isBooleanType ifTrue: [ ^ builder dynObjectIdentityNotEquals: value with: (builder addDynamicLiteral: false)].
	targetType isIntegerType ifTrue: [ ^ builder dynamicObjectToIntCast: value target: targetType ssaType ].
	targetType isFloatType ifTrue: [ ^ builder dynamicObjectToFloatCast: value target: targetType ssaType ].
	targetType isStructureType ifTrue: [ ^ builder dynamicObjectToStructureCast: value target: targetType ssaType typeObject: (builder addDynamicLiteral: targetType) ].
	targetType isSpecificDynamicObjectType ifTrue: [ ^ value ].
	
	targetType isPointerType ifTrue: [
		^ builder dynamicObjectToPointerCast: value target: targetType ssaType typeObject: (builder addDynamicLiteral: targetType)
	].
	
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node