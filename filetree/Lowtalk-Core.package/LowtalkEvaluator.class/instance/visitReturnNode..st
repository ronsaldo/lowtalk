visiting
visitReturnNode: node
	| returnValue |
	returnValue := self visitNode: node value.
	LowtalkInterpreterReturnException new
		value: returnValue;
		type: node value type;
		signal