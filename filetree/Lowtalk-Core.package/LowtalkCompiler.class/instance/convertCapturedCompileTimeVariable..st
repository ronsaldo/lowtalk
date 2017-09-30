module construction
convertCapturedCompileTimeVariable: compileTimeVariable
	| valueType variableName variable |
	capturedCompileTimeVariables at: compileTimeVariable ifPresent: [ :result | ^ result ].
	
	valueType := compileTimeVariable valueType.
	valueType isBlockType ifTrue: [ 
		self flag: 'HACK: For now we are just returning its value'.
		^ self convertDynamicObjectSSAConstant: (compileTimeVariable value).
	].

	self flag: 'Support debugging scopes'.

	variableName := (self generateSymbol , '_compile_time_capture') asSymbol.	
	variable := SLVMGlobalVariable module: ssaModule name: variableName valueType: valueType ssaType storage: SLVMType genericStorage.
	variable makePrivate;
		shouldBePromotedToConstant: true;
		propertyAt: #omitDebugInformation put: true.
	valueType isAnyDynamicObjectType ifTrue: [
		variable customSection: #'.oopRef'
	].
	variable propertyAt: #binding put: compileTimeVariable binding.
	capturedCompileTimeVariables at: compileTimeVariable put: variable.
	
	variable initialValue: (valueType convertValue: compileTimeVariable value toSSAConstantWith: self).
	^ variable
	