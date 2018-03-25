Extension { #name : #Array }

{ #category : #'*Lowtalk-Core' }
Array >> asLowtalkObjectInstanceWith: aCompiler [
	^ aCompiler objectModel convertArray: self
]
