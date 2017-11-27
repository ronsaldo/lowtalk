accessing
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	| temp |
	targetType isDynamicObjectType ifTrue: [
		^ builder structureToDynamicObjectCast: value target: targetType typeObject: (builder addDynamicLiteral: self)
	].

	(targetType isReferenceType and: [ targetType referenced == self ]) ifTrue: [
		temp := builder allocaBuilder alloca: self ssaType.
		builder store: value in: temp.
		^ temp
	].

	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node