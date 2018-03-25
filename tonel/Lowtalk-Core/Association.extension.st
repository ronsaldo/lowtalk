Extension { #name : #Association }

{ #category : #'*Lowtalk-Core' }
Association >> asLowtalkObjectInstanceWith: aCompiler [
	^ aCompiler objectModel convertAssociation: self
]
