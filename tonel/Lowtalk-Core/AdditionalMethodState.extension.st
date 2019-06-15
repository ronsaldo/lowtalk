Extension { #name : #AdditionalMethodState }

{ #category : #'*Lowtalk-Core' }
AdditionalMethodState >> asLowtalkObjectInstanceWith: aCompiler [
	^ aCompiler objectModel convertAdditionalMethodState: self
]

{ #category : #'*Lowtalk-Core' }
AdditionalMethodState >> method [

	^method.
]
