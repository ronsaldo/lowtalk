Extension { #name : #LiteralVariable }

{ #category : #'*Lowtalk-Core' }
LiteralVariable >> asLowtalkVariableReferenceFor: aCompiler [
	^ aCompiler importImageLiteralVariable: self
]
