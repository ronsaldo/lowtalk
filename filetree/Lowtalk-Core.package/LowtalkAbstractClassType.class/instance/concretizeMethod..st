methods
concretizeMethod: aMethod
	| actualMethod |
	methodSignatureDictionary at: aMethod selector ifAbsentPut: [ aMethod methodSignatureForReceiverTypeValue: self ].
	actualMethod := aMethod compiledMethodForReceiverTypeValue: self.
	pendingMethods removeKey: aMethod selector.
	self installMethod: actualMethod category: 	(organization at: aMethod ifAbsent: [ self defaultMethodCategory ]).