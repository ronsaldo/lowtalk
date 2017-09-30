as yet unclassified
importImageClassType: aBehavior
	self assert: isSandboxed not.
	^ importedImageClasses at: aBehavior ifAbsentPut: [
		(LowtalkImageBehaviorType target: compilationTarget)
			compiler: self;
			behavior: aBehavior
	]