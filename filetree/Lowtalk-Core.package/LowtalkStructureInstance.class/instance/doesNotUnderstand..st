reflective operations
doesNotUnderstand: aMessage
	| arguments value valueType slot |
	arguments := aMessage arguments.
	arguments size = 0 ifTrue: [
		type slotNamed: aMessage selector ifPresent: [ :slotDescriptor |
			slot := slots at: slotDescriptor index + 1.
			^ slot value
		]
	].
	arguments size = 1 ifTrue: [ 
		type slotNamed: aMessage selector allButLast ifPresent: [ :slotDescriptor |
			slot := slots at: slotDescriptor index + 1.
			value := arguments first.
			valueType := value lowtalkLiteralTypeWith: type compiler.
			slot value: (valueType convertValue: value toType: slot valueType at: (LowtalkASTNode new)).
			^ self
		]
	].

	^ super doesNotUnderstand: aMessage