accessing
buildSSAFunction
	ssaValue := SLVMFunction module: compiler ssaModule name: self mangledName asSymbol functionType: self valueType ssaType.
	ssaValue gcStrategy: #lowtalk.
	ssaValue unmangledName: self name.

	self isExternal ifTrue: [
		ssaValue makeExternal.
		^ self.
	] ifFalse: [ 
		ssaValue makePublic.
	].

	self value ifNil: [ 
		self error: 'Non external function without definition'.
	].

	compiler compilationTarget emittingDebugInformation ifTrue: [
		ssaValue debugSourceLocation: (compiler convertDebugPosition: self rawValue definition node position).
	].

	compiler mapValue: self rawValue toSSAValue: ssaValue.
	compiler generateFunction: ssaValue value: self rawValue.
	