as yet unclassified
external: nameLazyValue symbol: symbolLazyValue type: typeLazyValue
	<compileTime>
	<lazy>
	
	| result |
	result := self named: nameLazyValue symbol: symbolLazyValue type: typeLazyValue value: nil.
	result isExternal: true.
	^ result