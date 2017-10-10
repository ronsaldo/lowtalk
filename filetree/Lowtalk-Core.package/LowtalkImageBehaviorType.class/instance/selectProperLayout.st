slots
selectProperLayout
	(objectSlots isNotEmpty and: [nativeSlots isNotEmpty]) ifTrue: [
		slotsExpression semanticError: 'Cannot mix dynamic object slots and native slots in a single class'.
	]