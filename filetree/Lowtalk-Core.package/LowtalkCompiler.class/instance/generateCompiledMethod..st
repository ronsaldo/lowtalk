as yet unclassified
generateCompiledMethod: method
	| ssaFunctionMetadata compiledMethodBinding |
	self assert: isSandboxed not.
	ssaFunctionMetadata := self generateInterpreterMethod: method.
	compiledMethodBinding := self finalCodeGenerator translateFinalModuleElement: ssaFunctionMetadata sourceMethod.
	^ compiledMethodBinding value
