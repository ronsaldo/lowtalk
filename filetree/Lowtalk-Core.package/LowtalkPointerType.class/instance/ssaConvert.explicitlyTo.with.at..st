coercions
ssaConvert: value explicitlyTo: targetType with: builder at: node
	(targetType isPointerType or: 
	 [targetType isIntegerType and: [ targetType size = self size ]]) ifTrue: [
		^ builder bitCast: value target: targetType ssaType
	].
	targetType isDynamicObjectType ifTrue: [
		^ builder pointerToDynamicObjectCast: value target: targetType ssaType typeObject: (builder addDynamicLiteral: self)
	].

	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node