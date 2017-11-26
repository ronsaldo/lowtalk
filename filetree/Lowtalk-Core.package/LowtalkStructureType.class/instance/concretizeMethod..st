methods
concretizeMethod: aMethod
	| actualMethod |
	(pendingMethods includesKey: aMethod selector) ifFalse: [ ^ self ].
	methodSignatureDictionary at: aMethod selector ifAbsentPut: [ aMethod methodSignatureForReceiverTypeValue: self ref ].
	actualMethod := aMethod compiledMethodForReceiverTypeValue: self ref.
	pendingMethods removeKey: aMethod selector.
	methodDict at: actualMethod selector put: actualMethod.
	self installMethod: actualMethod category: 	(organization at: aMethod ifAbsent: [ self defaultMethodCategory ]).