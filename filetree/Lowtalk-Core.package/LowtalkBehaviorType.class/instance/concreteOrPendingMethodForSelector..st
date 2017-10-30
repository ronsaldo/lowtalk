methods
concreteOrPendingMethodForSelector: selector
	pendingMethods at: selector ifPresent: [ :pendingMethod | ^ pendingMethod ].
	^ methodDict at: selector ifAbsent: [ nil ]