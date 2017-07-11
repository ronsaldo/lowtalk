coercions
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	value type isPointerType ifTrue: [
		self assert: targetType isDynamicObjectType.
		^ builder closureToDynamicObject: value target: targetType ssaType
	].
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node