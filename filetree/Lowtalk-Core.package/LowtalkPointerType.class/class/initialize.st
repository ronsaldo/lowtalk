initialization
initialize
	PointerMessages := Dictionary newFromPairs: #(
		value PointerDeReference
		at: PointerDeReference
		basicAt: PointerDeReference
		value: PointerElementAssignment
		at:put: PointerElementAssignment
		basicAt:put: PointerElementAssignment
		
		fetchAndAdd: AtomicFetchAndAdd
		fetchAndSubtract: AtomicFetchAndAdd
		swapValue: AtomicSwapValue
		
		+ PointerArithmetic
		- PointerArithmetic
	)