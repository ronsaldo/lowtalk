initialization
initialize
	PointerMessages := Dictionary newFromPairs: #(
		value PointerDeReference
		at: PointerDeReference
		value: PointerElementAssignment
		at:put: PointerElementAssignment
		
		+ PointerArithmetic
		- PointerArithmetic
	)