class creation
createNamedFormat: formatName withInstanceSize: instanceSize
	^ createNamedFormatSpec lowtalkValueWithArguments: { formatName . instanceSize } types: { compiler objectType . compiler integerLiteralType } compiler: compiler at: nil