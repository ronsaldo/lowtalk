accessing
buildSSAFunction
	ssaValue := SLVMFunction module: compiler ssaModule name: self mangledName functionType: self valueType ssaType.
	self isExternal ifTrue: [
		ssaValue makeExternal.
		^ self.
	].

	self value ifNil: [ 
		self error: 'Non external function without definition'.
	].
	
	compiler generateFunction: ssaValue value: self value.
	
