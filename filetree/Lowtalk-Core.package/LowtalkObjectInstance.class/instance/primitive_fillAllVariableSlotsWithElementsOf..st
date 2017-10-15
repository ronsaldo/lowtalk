object primitives
primitive_fillAllVariableSlotsWithElementsOf: aSequence
	| type fixedSize |
	type := self behavior asClassType.
	fixedSize := type instanceSize.
	self assert: slots size = (aSequence size + fixedSize).
	1 to: aSequence size do: [ :i | slots at: fixedSize + i put: (aSequence at: i) ].