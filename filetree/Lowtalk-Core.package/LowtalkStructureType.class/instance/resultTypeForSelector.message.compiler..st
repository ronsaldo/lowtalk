accessing
resultTypeForSelector: selector message: messageNode compiler: aCompiler
	| precedence |	
	precedence := selector precedence.
	precedence = 1 ifTrue: [
		self slotNamed: selector ifPresent: [ :slotDescription |
			^ slotDescription type ref
		]
	].
	precedence = 3 ifTrue: [
		self slotNamed: selector allButLast ifPresent: [ :slotDescription |
			^ slotDescription type ref
		]
	].

	^ super resultTypeForSelector: selector message: messageNode compiler: aCompiler