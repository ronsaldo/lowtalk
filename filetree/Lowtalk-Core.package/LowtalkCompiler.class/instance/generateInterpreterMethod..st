as yet unclassified
generateInterpreterMethod: method
	| functionType ssaValue ssaMetadata |
	objectSSAValueMap at: method ifPresent: [ :oldValue | ^ oldValue ].
	objectInstanceVariableMap at: method ifPresent: [ :variable | ^ variable ssaValue ].

	functionType := method type.
	functionType isBlockType ifTrue: [ functionType := functionType functionType ].

	ssaValue := SLVMFunction pointerSize: compilationTarget pointerSize functionType: functionType ssaType.
	ssaValue compilationTarget: compilationTarget.
	ssaValue makePrivate.
	(method selector isNotNil and: [method methodClass isNotNil]) ifTrue: [ 
		ssaValue unmangledName: method methodClass name , '>>' , method selector
	].
	ssaModule add: ssaValue.

	ssaMetadata := ssaValue compiledMethodMetaDataValue.
	self mapValue: method toSSAValue: ssaMetadata.
	self generateFunction: ssaValue value: method.
	
	^ ssaMetadata