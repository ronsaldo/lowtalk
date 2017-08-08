visiting
generateTemp
	| symbol |
	symbol := self generateSymbol.
	irBuilder addTemp: symbol.
	^ symbol
	