module construction
registerMangledNameOf: variable
	| result |
	result := variable mangledName asSymbol.
	unmangledSymbolMap at: result put: variable name asSymbol.
	^ result