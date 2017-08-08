initialization
initializeTemporary: temp
	irBuilder
		addTemp: temp compiledMethodVariable.

	temp isInlineArgument ifFalse: [ 
		temp compiledMethodVariableIsSlot: true.

		irBuilder
			pushLiteral: temp valueType defaultValue;
			send: #asLowtalkVariableSlot;
			storeTemp: temp compiledMethodVariable;
			popTop
	].