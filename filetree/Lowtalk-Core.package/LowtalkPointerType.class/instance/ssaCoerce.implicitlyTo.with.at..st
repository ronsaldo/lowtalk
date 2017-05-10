coercions
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	(targetType isPointerType and: [ targetType pointed isVoidType ]) ifTrue: [ ^ value ].
	
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node