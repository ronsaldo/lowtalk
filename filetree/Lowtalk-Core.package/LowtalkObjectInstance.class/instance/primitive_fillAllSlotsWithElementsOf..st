object primitives
primitive_fillAllSlotsWithElementsOf: aSequence
	self assert: slots size = aSequence size.
	1 to: slots size do: [ :i | slots at: i put: (aSequence at: i) ].