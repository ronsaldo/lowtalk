coercions
irCoerceImplicitlyTo: targetType with: irBuilder at: node
	targetType isNilType ifTrue: [ ^ self ].
	^ super irCoerceImplicitlyTo: targetType with: irBuilder at: node