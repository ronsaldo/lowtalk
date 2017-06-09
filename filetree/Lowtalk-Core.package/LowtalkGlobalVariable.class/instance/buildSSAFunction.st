accessing
buildSSAFunction
	ssaValue := SLVMFunction module: compiler ssaModule name: self mangledName asSymbol functionType: self valueType ssaType.
	self isExternal ifTrue: [
		ssaValue makeExternal.
		^ self.
	] ifFalse: [ 
		ssaValue makePublic.
	].

	self value ifNil: [ 
		self error: 'Non external function without definition'.
	].

	compiler mapValue: value toSSAValue: ssaValue.
	compiler generateFunction: ssaValue value: value.
	
