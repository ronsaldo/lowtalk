top level entry points
captureInClosure: aValue
	| parentValue capture |
	aValue isFunctionLocalValue ifFalse: [ ^ aValue ].
	aValue function == currentFunction  ifTrue: [ ^ aValue ].
	self assert: parentCodeGenerator isNotNil.
	parentValue := parentCodeGenerator captureInClosure: aValue.
	capturedValueDictionary at: parentValue ifPresent: [ :result | ^ result ].
	
	capture := currentFunction createClosureCaptureOfType: aValue type.

	capturedValueDictionary at: parentValue put: capture.
	capturedValues add: parentValue.
	^ capture