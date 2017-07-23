as yet unclassified
generateInterpreterMethod: method
	| functionType ssaValue ssaMetadata |
	objectSSAValueMap at: method ifPresent: [ :oldValue | ^ oldValue ].
	objectInstanceVariableMap at: method ifPresent: [ :variable | ^ variable ssaValue ].

	functionType := method type.
	functionType isBlockType ifTrue: [ functionType := functionType functionType ].

	ssaValue := SLVMFunction pointerSize: compilationTarget pointerSize functionType: functionType ssaType.
	ssaValue compilationTarget: compilationTarget.
	method publicSymbol ifNotNil: [ 
		ssaValue name: method publicSymbol;
			makeExternal.
	] ifNil: [
		ssaValue makePrivate.
	].
	
	method primitive ifNotNil: [ ssaValue primitive: method ].
	method unmangledName ifNotNil: [ 
		ssaValue unmangledName: method unmangledName
	] ifNil: [ 
		(method selector isNotNil and: [method methodClass isNotNil]) ifTrue: [ 
			ssaValue unmangledName: method methodClass name , '>>' , method selector printString
		]
	].
	ssaModule add: ssaValue.
	compilationTarget emittingDebugInformation ifTrue: [
		ssaValue debugSourceLocation: (self convertDebugPosition: method node position).
	].

	ssaMetadata := ssaValue compiledMethodMetaDataValue.
	self mapValue: method toSSAValue: ssaMetadata.
	self generateFunction: ssaValue value: method.
	
	^ ssaMetadata