*Lowtalk-Core
category: categoryName methods: aCollectionOfMethods
	| type |
	aCollectionOfMethods ifEmpty: [ ^ self ].
	type := self asLowtalkTypeWith: aCollectionOfMethods first compiler.
	type category: categoryName methods: aCollectionOfMethods
