converting
truncateLiteralValue: value at: aNode
	| bitMask signBit bitCount |
	bitCount := self size * 8.
	bitMask := (1 << bitCount) - 1.
	^ self isSigned ifTrue: [
		signBit := (1<< (bitCount - 1)).
		(value bitAnd: bitMask - signBit) - (value bitAnd: signBit)
	] ifFalse: [ value bitAnd: bitMask ]