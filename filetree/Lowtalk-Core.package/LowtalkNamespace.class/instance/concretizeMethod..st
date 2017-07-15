accessing
concretizeMethod: aMethod
	| actualMethod mangledSelector methodPublicSymbol |
	actualMethod := aMethod compiledMethodForReceiverTypeValue: compiler voidType.
	pendingMethods removeKey: aMethod selector.
	
	mangledSelector := self mangleSelector: aMethod selector.
	methodPublicSymbol := self mangledName , mangledSelector size asString , mangledSelector , '_method'.
	actualMethod
		publicSymbol: methodPublicSymbol asSymbol;
		unmangledName: self fullName , '>>' , aMethod selector printString.
	methods at: actualMethod selector put: actualMethod