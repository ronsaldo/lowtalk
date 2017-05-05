as yet unclassified
external: nameLazyValue type: typeLazyValue
	<compileTime>
	<lazy>
	
	| result |
	result := self named: nameLazyValue type: typeLazyValue value: nil.
	result isExternal: true.
	^ result