initialization
initialize
	PointerMessages := Dictionary newFromPairs: #(
		value PointerDeReference
		at: PointerDeReference
		value: PointerElementAssignment
		at:put: PointerElementAssignment
		
		fetchAndAdd: AtomicFetchAndAdd
		fetchAndSubtract: AtomicFetchAndAdd
		swapValue: AtomicSwapValue
		
		+ PointerArithmetic
		- PointerArithmetic
	)