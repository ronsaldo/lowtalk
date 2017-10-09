accessing
compiler
	^ compiler ifNil: [ compiler := LowtalkCompiler compilationTarget: SLVMCompilationTarget forCurrentImage ]