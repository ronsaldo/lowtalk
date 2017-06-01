module construction
convertDynamicObjectSSAConstant: value
	^ compilationTarget objectModel convertConstantValue: value inModule: ssaModule