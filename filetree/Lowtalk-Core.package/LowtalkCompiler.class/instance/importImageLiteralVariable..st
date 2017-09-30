as yet unclassified
importImageLiteralVariable: aLiteralVariable
	self assert: isSandboxed not.
	^ importedImageLiteralVariables at: aLiteralVariable ifAbsentPut: [
		LowtalkImageVariable new binding: aLiteralVariable; type: self objectType
	]