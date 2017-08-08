coercions
irCoerceImplicitlyTo: targetType with: irBuilder at: node
	targetType isDynamicObjectType ifTrue: [ ^ self ].
	^ super irCoerceImplicitlyTo: targetType with: irBuilder at: node