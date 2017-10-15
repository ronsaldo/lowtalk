compiling
finishBuildingObject
	super compileElement.
	self classObject
		lowtalkPerform: #finishImportDataFromType:
		withArguments: { self } types: { compiler objectType } inSuperclass: false node: nil compiler: compiler.