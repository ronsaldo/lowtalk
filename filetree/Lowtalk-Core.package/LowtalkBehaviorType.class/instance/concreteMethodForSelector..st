methods
concreteMethodForSelector: selector
	pendingMethods at: selector ifPresent: [ :pendingMethod | self concretizeMethod: pendingMethod ].
	^ methodDict at: selector ifAbsent: [ nil ]