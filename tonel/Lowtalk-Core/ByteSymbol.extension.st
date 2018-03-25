Extension { #name : #ByteSymbol }

{ #category : #'*Lowtalk-Core' }
ByteSymbol >> asLowtalkObjectInstanceWith: aCompiler [
	^ aCompiler objectModel convertByteSymbol: self
]
