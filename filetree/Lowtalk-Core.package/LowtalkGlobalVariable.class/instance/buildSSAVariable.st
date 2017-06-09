accessing
buildSSAVariable
	ssaValue := SLVMGlobalVariable module: compiler ssaModule name: self mangledName asSymbol valueType: self valueType ssaType storage: SLVMType genericStorage.

	self isExternal ifTrue: [
		ssaValue makeExternal.
	] ifFalse: [ 
		ssaValue makePublic.
	].

	self isConstant ifTrue: [ 
		ssaValue readOnly: true
	].

	self value ifNotNil: [ :actualValue |
		ssaValue initialValue: (compiler translateSSAConstant: actualValue type: self valueType)
	].