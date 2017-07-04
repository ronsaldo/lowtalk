accessing
concreteMethodForSelector: selector
	pendingMethods at: selector ifPresent: [ :pendingMethod | self concretizeMethod: pendingMethod ].
	^ methods at: selector ifAbsent: [ nil ]