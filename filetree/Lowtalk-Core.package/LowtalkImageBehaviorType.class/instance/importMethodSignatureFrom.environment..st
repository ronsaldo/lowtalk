methods
importMethodSignatureFrom: compiledMethod environment: anEnvironment
	| signature |
	signature := compiledMethod propertyAt: #lowtalkMethodSignature ifAbsent: nil.
	signature ifNil: [
		signature := MethodSignatureSpecs at: compiledMethod ifAbsent: [ nil ].
		signature ifNil: [ ^ nil]
	].

	^ compiler evaluateString: signature