coercions
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	targetType = self ifTrue: [ ^ value ].
	targetType isVoidType ifTrue: [ ^ value ].
	^ targetType defaultSSAValueWith: builder