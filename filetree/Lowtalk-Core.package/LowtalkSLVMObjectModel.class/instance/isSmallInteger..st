testing
isSmallInteger: integer
	target pointerSize = 4 ifTrue: [
		^ integer between: -1073741824 and: 1073741823
	] ifFalse: [
		^ integer between: -1152921504606846976 and: 1152921504606846975
	]
	