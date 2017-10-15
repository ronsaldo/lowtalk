initialization
initialize
	ClassPrimitiveSelectors := Dictionary newFromPairs: #(
		basicNew classPrimitive_basicNew
		basicNew: classPrimitive_basicNew:
	).
	
	ObjectPrimitiveSelectors := Dictionary newFromPairs: #(
		basicAt: primitive_basicAt:
		basicAt:put: primitive_basicAt:put:
		basicSize primitive_basicSize
		
		identityHash primitive_identityHash
		class primitive_class
		== primitive_identityEquals:
		~~ primitive_identityNotEquals:
		castTo: primitive_castTo:
		reinterpretCastTo: primitive_reinterpretCastTo:
		yourself primitive_yourself
		__fillAllSlotsWithElementsOf: primitive_fillAllSlotsWithElementsOf:
		__fillAllSlotsWithIntegerElementsOf: primitive_fillAllSlotsWithIntegerElementsOf:
		__fillAllVariableSlotsWithElementsOf: primitive_fillAllVariableSlotsWithElementsOf:
		).
	