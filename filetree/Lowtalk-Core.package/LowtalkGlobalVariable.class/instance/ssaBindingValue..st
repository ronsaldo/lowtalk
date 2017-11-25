accessing
ssaBindingValue: aBindingValue
	ssaBindingValue := aBindingValue.
	ssaValue ifNotNil: [
		ssaValue propertyAt: #binding put: ssaBindingValue
	]