Extension { #name : #SequenceableCollection }

{ #category : #'*Lowtalk-Core' }
SequenceableCollection >> asLowtalkCollectionWithContext [
	^ LowtalkCollectionWithContext new collection: self
]
