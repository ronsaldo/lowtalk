visiting
visitReturnNode: node
	| returnValue |
	returnValue := node value accept: self.
	LowtalkInterpreterReturnException new
		value: returnValue;
		type: node value type;
		signal