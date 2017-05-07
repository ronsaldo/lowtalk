coercions
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	referenced = targetType ifTrue: [
		referenced isFunctionType ifTrue: [ ^ value ].
		^ builder load: value
	].

	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node