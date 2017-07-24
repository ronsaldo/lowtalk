initialization
initialize
	ThisContextSpecialMessageTypes := Dictionary newFromPairs: #(
		uncheckedReplaceFunctionWith: UncheckedReplaceContextFunction
		uncheckedFramePointer UncheckedFramePointer
		uncheckedReturnFromFrame:value:exitPoint: UncheckedReturnFromFrameValue
	)