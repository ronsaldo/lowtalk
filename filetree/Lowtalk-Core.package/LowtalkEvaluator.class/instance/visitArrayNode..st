visiting
visitArrayNode: node
	^ node expressionList collect: [ :element | self evaluateValue: element ]