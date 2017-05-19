converting
truncateLiteralValue: value at: aNode
	^ Float fromIEEE32Bit: (value asIEEE32BitWord)