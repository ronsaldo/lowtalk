object primitives
primitive_fillAllSlotsWithIntegerElementsOf: aSequence
	self assert: slots size = aSequence size.
	1 to: slots size do: [ :i | slots at: i put: (aSequence at: i) asInteger ].