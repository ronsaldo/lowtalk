accessing
buildSSAVariable
	ssaValue := SLVMGlobalVariable module: compiler ssaModule name: self mangledName asSymbol valueType: self valueType ssaType storage: SLVMType genericStorage.
	ssaValue unmangledName: self name.
	
	self valueType isAnyDynamicObjectType ifTrue: [ 
		ssaValue customSection: #'.oop'.
		ssaValue headerValue: (compiler ssaModule compilationTarget objectModel
			createObjectVariableHeaderClass: compiler objectModel globalVariableClass name: self name)
	] ifFalse: [ 
		self flag: 'TODO: Support the non-object variables.'
	].
	
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