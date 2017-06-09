initialization
initialize
	ArrayMessages := Dictionary newFromPairs: #(
		value PointerDeReference
		at: PointerDeReference
		basicAt: PointerDeReference
		value: PointerElementAssignment
		at:put: PointerElementAssignment
		basicAt:put: PointerElementAssignment
	)