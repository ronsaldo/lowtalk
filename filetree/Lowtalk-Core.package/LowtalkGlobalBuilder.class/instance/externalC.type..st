as yet unclassified
externalC: nameLazyValue type: typeLazyValue
	<compileTime>
	<lazy>
	
	| result |
	result := self external: nameLazyValue type: typeLazyValue.
	result isVisibleInC: true.
	^ result