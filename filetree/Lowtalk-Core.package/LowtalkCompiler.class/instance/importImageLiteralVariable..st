as yet unclassified
importImageLiteralVariable: aLiteralVariable
	self assert: isSandboxed not.
	^ importedImageLiteralVariables at: aLiteralVariable ifAbsentPut: [
		LowtalkImageVariable new
			binding: aLiteralVariable;
			compiler: self;
			type: self objectType
	]