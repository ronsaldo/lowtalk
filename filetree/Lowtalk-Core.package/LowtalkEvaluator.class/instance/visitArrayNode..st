visiting
visitArrayNode: node
	node type: compiler objectType.
	^ node expressionList collect: [ :element | self evaluateValue: element ].