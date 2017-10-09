visiting
visitIdentifierReferenceNode: identifier
	| result |
	result := (environment lookSymbolRecursively: identifier value ifAbsent: [
		identifier environment: environment semanticError: 'Undeclared identifier {1}' format: { identifier value }
	]) asLowtalkVariableReferenceFor: compiler.

	self flag: 'Remove this hack interpreting inlined closures in a proper way'.
	identifier binding ifNil: [
		identifier binding: result.
		
		(result isMethodVariable and: [result isMethodReceiverSlot not]) ifTrue: [
			result method ~~ method ifTrue: [ 
				self captureMethodVariable: result
			]
		].
	].

	self assert: identifier binding class ~~ LowtalkSlotPointer.
	identifier type: result type.
	^ result