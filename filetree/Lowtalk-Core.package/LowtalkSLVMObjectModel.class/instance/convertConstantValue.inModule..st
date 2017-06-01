as yet unclassified
convertConstantValue: value inModule: module
	(self isInlineLiteral: value) ifTrue: [ ^ self convertInlineLiteral: value ].
	^ compiler doConvertSSADynamicConstantValue: value inModule: module