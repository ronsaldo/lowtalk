private
generateSymbol
	gensymCount := gensymCount + 1.
	^ self convertTemporaryName: ('__ltigsym' , gensymCount asString) asSymbol