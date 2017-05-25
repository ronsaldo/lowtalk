coercions
ssaConvert: value explicitlyTo: targetType with: builder at: node
	self = targetType ifTrue: [ ^ value ].
	self error: 'Unimplemented type explicit conversion.'