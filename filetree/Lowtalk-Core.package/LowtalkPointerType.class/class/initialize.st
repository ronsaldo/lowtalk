initialization
initialize
	PointerMessages := Dictionary newFromPairs: #(
		at: PointerDeReference
		basicAt: PointerDeReference
		atOffset: PointerDeReference
		basicAtOffset: PointerDeReference

		at:put: PointerElementAssignment
		basicAt:put: PointerElementAssignment
		atOffset:put: PointerElementAssignment
		basicAtOffset:put: PointerElementAssignment

		value PointerDeReference
		value: PointerElementAssignment
		
		fetchAndAdd: AtomicFetchAndAdd
		fetchAndSubtract: AtomicFetchAndAdd
		swapValue: AtomicSwapValue
		
		+ PointerArithmetic
		- PointerArithmetic
	)