as yet unclassified
generateInterpreterMethod: method
	| functionType ssaValue |
	objectSSAValueMap at: method ifPresent: [ :oldValue | ^ oldValue ].
	objectInstanceVariableMap at: method ifPresent: [ :variable | ^ variable ssaValue ].

	functionType := method node type.
	functionType isBlockType ifTrue: [ functionType := functionType functionType ].

	ssaValue := SLVMFunction pointerSize: compilationTarget pointerSize functionType: functionType ssaType.
	ssaValue compilationTarget: compilationTarget.
	ssaValue makePrivate.
	ssaModule add: ssaValue.
	
	self mapValue: method toSSAValue: ssaValue.
	self generateFunction: ssaValue value: method.
	
	^ ssaValue