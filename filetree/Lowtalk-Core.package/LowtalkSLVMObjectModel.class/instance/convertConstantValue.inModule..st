trampoline names
convertConstantValue: value inModule: module
	value isSLVMObject ifTrue: [
		self assert: (value type isPointerType or: [value type isDynamicObjectType]).
		(value isFunction or: [value isFunctionExitPoint]) ifTrue: [
			^ SLVMConstant pointer:
				(SLVMConstant add: (SLVMConstant pointer: value castTo: compiler uintPointerType ssaType) with:
				(SLVMConstant type: compiler uintPointerType ssaType value: 1))
				castTo: compiler objectType ssaType
		] ifFalse: [
			^ SLVMConstant pointer: value castTo: compiler objectType ssaType
		]
	].

	(self isInlineLiteral: value) ifTrue: [ ^ self convertInlineLiteral: value ].
	^ compiler doConvertSSADynamicConstantValue: value inModule: module