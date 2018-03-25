Extension { #name : #Behavior }

{ #category : #'*Lowtalk-Core' }
Behavior >> asLowtalkImportedValueWith: aCompiler [
	^ self asLowtalkTypeWith: aCompiler
]

{ #category : #'*Lowtalk-Core' }
Behavior >> asLowtalkObjectInstanceWith: aCompiler [
	^ aCompiler objectModel convertBehavior: self
	
]

{ #category : #'*Lowtalk-Core' }
Behavior >> asLowtalkTypeWith: aLowtalkCompiler [
	^ aLowtalkCompiler importImageClassType: self
]

{ #category : #'*Lowtalk-Core' }
Behavior >> category: categoryName methods: aCollectionOfMethods [
	| type |
	aCollectionOfMethods ifEmpty: [ ^ self ].
	type := self asLowtalkTypeWith: aCollectionOfMethods first compiler.
	type category: categoryName methods: aCollectionOfMethods

]
