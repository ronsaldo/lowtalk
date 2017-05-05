accessing
buildSSAFunction
	ssaValue := SLVMFunction module: compiler ssaModule name: self mangledName functionType: self valueType ssaType.
	self isExternal ifTrue: [
		ssaValue makeExternal.
		^ self.
	].
	
	
