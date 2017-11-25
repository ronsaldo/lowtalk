code generation
buildSSAValue
	ssaValue := SLVMGlobalVariable module: compiler ssaModule name: name valueType: self valueType ssaType storage: SLVMType genericStorage.
	ssaValue makePrivate;
		propertyAt: #omitDebugInformation put: true;
		propertyAt: #binding put: self capturedBinding