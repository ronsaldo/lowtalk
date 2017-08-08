coercions
irConvertExplicitlyTo: targetType with: builder at: node
	(referenced canBeExplicitlyConvertedTo: targetType) ifTrue: [
		builder send: #value.
		^ referenced irConvertExplicitlyTo: targetType with: builder at: node
	].

	^ super irConvertExplicitlyTo: targetType with: builder at: node