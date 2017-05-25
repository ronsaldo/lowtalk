converting
convertValue: value toType: targetType at: aNode
	targetType isSpecificDynamicObjectType ifTrue: [
		(targetType isValueConforming: value) ifFalse: [
			(aNode semanticError: 'Cannot convert value of type {1} to type {2}.') format: { self name . targetType name }.
		].
		^ value
	].

	^ super convertValue: value toType: targetType at: aNode