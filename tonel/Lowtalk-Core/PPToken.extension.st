Extension { #name : #PPToken }

{ #category : #'*Lowtalk-Core' }
PPToken >> asLowtalkASTPosition [
	^ LowtalkASTPosition new
		collection: collection;
		start: start;
		stop: stop;
		yourself
]
