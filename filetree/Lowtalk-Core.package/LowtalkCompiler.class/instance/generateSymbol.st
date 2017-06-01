initialization
generateSymbol
	gensymCount := gensymCount + 1.
	^ ('__ltgsym' , gensymCount asString) asSymbol