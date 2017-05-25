object primitives
primitive_castTo: targetTypeLazyValue
	| targetType |
	targetType := targetTypeLazyValue value asLowtalkTypeIn: targetTypeLazyValue node.
	^ self type convertValue: self toType: targetType at: targetTypeLazyValue node