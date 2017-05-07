coercions
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	self = targetType ifTrue: [ ^ value ].
	self error: 'Unimplemented type coercion conversion.'