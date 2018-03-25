Extension { #name : #Fraction }

{ #category : #'*Lowtalk-Core' }
Fraction >> lowtalkLiteralTypeWith: aLowtalkCompiler [
	^ aLowtalkCompiler rationalLiteralType
]
