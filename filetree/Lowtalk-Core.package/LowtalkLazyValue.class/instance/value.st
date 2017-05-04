accessing
value
	evaluated ifFalse: [
		value := evaluator evaluate: node.
		evaluated := true.
	].

	^ value