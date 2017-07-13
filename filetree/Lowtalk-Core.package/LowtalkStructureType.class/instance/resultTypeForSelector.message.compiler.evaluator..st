accessing
resultTypeForSelector: selector message: messageNode compiler: aCompiler evaluator: evaluator
	| precedence |	
	precedence := selector precedence.
	(self concreteMethodForSelector: selector) ifNotNil: [ 
		self halt
	].
	
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

	^ super resultTypeForSelector: selector message: messageNode compiler: aCompiler evaluator: evaluator