object creation
convertBoxedFloat64: aFloat
	| data bytes |
	data := ((aFloat basicAt: 1) << 32) | (aFloat basicAt: 2).
	bytes := ByteArray new: 8.
	bytes unsignedLongLongAt: 1 put: data.
	^ convertBoxedFloat64Function value: data