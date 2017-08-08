coercions
irCoerceImplicitlyTo: targetType with: builder at: node
	(referenced canBeImplicitlyConvertedTo: targetType) ifTrue: [
		builder send: #value.
		^ referenced irCoerceImplicitlyTo: targetType with: builder at: node
	].

	^ super irCoerceImplicitlyTo: targetType with: builder at: node