Extension { #name : #BlockClosure }

{ #category : #'*Lowtalk-Core' }
BlockClosure >> asLowtalkBlockClosureFor: interpreterMethod [
	^ LowtalkCompiledMethodBlockClosure new closure: self; definition: interpreterMethod; yourself
]
