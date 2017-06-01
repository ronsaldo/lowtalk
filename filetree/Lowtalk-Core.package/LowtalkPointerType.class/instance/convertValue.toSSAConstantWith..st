converting
convertValue: value toSSAConstantWith: compiler
	value ifNil: [ ^ SLVMConstant type: self ssaType value: 0 ].
	value isInteger ifTrue: [ ^ SLVMConstant type: self ssaType value: value ].
	value isCompileTimePointer ifTrue: [ ^ value toSSAPointerConstantWith: compiler ].
	self halt