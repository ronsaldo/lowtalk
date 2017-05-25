visiting
visitArrayNode: node
	node setTypeIfNil: compiler objectType.
	^ node expressionList collect: [ :element | self evaluateValue: element ].