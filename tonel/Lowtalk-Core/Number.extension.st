Extension { #name : #Number }

{ #category : #'*Lowtalk-Core' }
Number >> lowtalkTruncateLiteralValueWithType: aType [
	^ aType truncateLiteralValue: self at: nil
]
