accessing
rawValue: aValue
	aValue class == LowtalkGlobalVariable ifTrue: [self halt].
	^ self binding value: aValue