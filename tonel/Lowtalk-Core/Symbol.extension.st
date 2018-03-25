Extension { #name : #Symbol }

{ #category : #'*Lowtalk-Core' }
Symbol >> asLowtalkSlotWith: aCompiler [
	^ LowtalkSlot new
			name: self;
			type: aCompiler objectType;
			yourself
]

{ #category : #'*Lowtalk-Core' }
Symbol >> lowtalkLiteralTypeWith: aLowtalkCompiler [
	^ aLowtalkCompiler symbolLiteralType
]
