as yet unclassified
external: nameLazyValue C: cNameLazyValue type: typeLazyValue
	<compileTime>
	<lazy>
	
	| result |
	result := self external: nameLazyValue symbol: cNameLazyValue type: typeLazyValue.
	result isVisibleInC: true.
	^ result