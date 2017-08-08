visiting
captureMethodVariable: methodVariable
	self assert: methodVariable method isNotNil.
	methodVariable method == method ifTrue: [ ^ self ].
	
	methodVariable isCapturedInClosure: true.
	methodVariable method addCapturedVariable: methodVariable.
	method addOuterClosureVariable: methodVariable