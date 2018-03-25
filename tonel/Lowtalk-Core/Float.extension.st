Extension { #name : #Float }

{ #category : #'*Lowtalk-Core' }
Float >> asLowtalkObjectInstanceWith: aCompiler [
	^ aCompiler objectModel convertBoxedFloat64: self
]

{ #category : #'*Lowtalk-Core' }
Float >> lowtalkLiteralTypeWith: aLowtalkCompiler [
	^ aLowtalkCompiler floatLiteralType
]
