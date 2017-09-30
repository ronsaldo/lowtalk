accessing
ssaModule
	^ ssaModule ifNil: [ssaModule := SLVMModule new compilationTarget: compilationTarget].