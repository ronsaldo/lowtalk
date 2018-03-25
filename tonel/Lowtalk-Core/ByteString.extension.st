Extension { #name : #ByteString }

{ #category : #'*Lowtalk-Core' }
ByteString >> asLowtalkObjectInstanceWith: aCompiler [
	^ aCompiler objectModel convertByteString: self
]
