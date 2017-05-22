coercions
ssaConvert: value explicitlyTo: targetType with: builder at: node
	(targetType isPointerType or: 
	 [targetType isIntegerType and: [ targetType size = self size ]]) ifTrue: [
		^ builder bitCast: value target: targetType ssaType
	].
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node