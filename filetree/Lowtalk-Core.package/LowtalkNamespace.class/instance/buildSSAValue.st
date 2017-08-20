code generation
buildSSAValue
	ssaValue ifNotNil: [ ^ self ].
	compiler objectModel namespaceCreationFunction ifNil: [ ^ self ].
	
	ssaValue := SLVMGlobalVariable module: compiler ssaModule name: self mangledName asSymbol valueType: compiler objectType ssaType storage: SLVMType genericStorage.
	ssaValue unmangledName: self name.
	
	ssaValue customSection: #'.oop'.
	ssaValue headerValue: (compiler ssaModule compilationTarget objectModel
			createObjectVariableHeaderClass: compiler objectModel globalVariableClass name: self name).
	ssaValue makePublic.
