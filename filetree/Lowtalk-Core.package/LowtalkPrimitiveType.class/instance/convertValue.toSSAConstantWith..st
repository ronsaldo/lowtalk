converting
convertValue: value toSSAConstantWith: compiler
	^ SLVMConstant type: self ssaType value: value