accessing
buildSSAVariable
	ssaValue := SLVMGlobalVariable module: compiler ssaModule name: self mangledName valueType: self valueType ssaType storage: SLVMType genericStorage.

	self isExternal ifTrue: [
		ssaValue makeExternal.
	].
	self isConstant ifTrue: [ 
		ssaValue readOnly: true
	].