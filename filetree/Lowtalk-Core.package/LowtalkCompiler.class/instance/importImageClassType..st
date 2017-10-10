as yet unclassified
importImageClassType: aBehavior
	| result |
	self assert: isSandboxed not.
	^ importedImageClasses at: aBehavior ifAbsentPut: [
		result :=
		(LowtalkImageBehaviorType target: compilationTarget)
			compiler: self;
			classObject: aBehavior.
		self addPendingObject: result.
		result
	]