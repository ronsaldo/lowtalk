as yet unclassified
toSSAPointerConstantWith: aCompiler
	| objectPointer headerPointerType |
	objectPointer := object toSSAPointerConstantWith: aCompiler.
	headerPointerType := aCompiler objectModel headerType pointer ssaType.
	^ SLVMConstant pointer: objectPointer castTo: headerPointerType