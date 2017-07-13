coercions
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	(targetType isPointerType and: [ targetType pointed isVoidType ]) ifTrue: [
		^ builder bitCast: value target: targetType ssaType
	].

	targetType isDynamicObjectType ifTrue: [
		^ builder pointerToDynamicObjectCast: value target: targetType ssaType typeObject: (builder addDynamicLiteral: self)
	].
	
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node