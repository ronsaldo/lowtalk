coercions
ssaConvert: value explicitlyTo: targetType with: builder at: node
	(referenced canBeExplicitlyConvertedTo: targetType) ifTrue: [
		referenced isFunctionType ifTrue: [ ^ value ].
		^ referenced ssaConvert: (builder load: value) explicitlyTo: targetType with: builder at: node
	].

	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node