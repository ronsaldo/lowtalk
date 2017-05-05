accessing
value
	evaluated ifFalse: [
		value := evaluator evaluateValue: node.
		evaluated := true.
	].

	^ value