object primitives
primitive_reinterpretCastTo: targetTypeLazyValue
	| targetType |
	targetType := targetTypeLazyValue value.
	(targetType isPointerType or: [ targetType isAnyDynamicObjectType ]) ifTrue: [ ^ self ].
	targetTypeLazyValue semanticError: 'Cannot reinterpret object of type {1} into type {2}.' format: { self type name . targetType name }