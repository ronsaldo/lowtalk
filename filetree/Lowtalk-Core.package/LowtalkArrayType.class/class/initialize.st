initialization
initialize
	ArrayMessages := Dictionary newFromPairs: #(
		value PointerDeReference
		at: PointerDeReference
		basicAt: PointerDeReference
		atOffset: PointerDeReference
		basicAtOffset: PointerDeReference
		
		value: PointerElementAssignment
		
		atOffset:put: PointerElementAssignment
		basicAtOffset:put: PointerElementAssignment
	)