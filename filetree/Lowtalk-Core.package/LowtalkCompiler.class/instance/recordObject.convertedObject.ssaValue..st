as yet unclassified
recordObject: value convertedObject: convertedObject ssaValue: ssaValue
	convertedSSAObjects at: value put: ssaValue.
	convertedSSAObjects at: convertedObject put: ssaValue.
	^ ssaValue