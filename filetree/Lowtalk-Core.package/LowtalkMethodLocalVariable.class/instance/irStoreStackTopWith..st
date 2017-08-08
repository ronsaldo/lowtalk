as yet unclassified
irStoreStackTopWith: irBuilder
	compiledMethodVariableIsSlot ifTrue: [ 
		irBuilder
			pushTemp: compiledMethodVariable;
			send: #lowtalkStoreValueIntoSlot:
	] ifFalse: [ 
		irBuilder storeTemp: compiledMethodVariable
	]
	