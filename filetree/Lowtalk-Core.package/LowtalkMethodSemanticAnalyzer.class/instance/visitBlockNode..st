visiting
visitBlockNode: node
	node definition: (self class new analyzeBlock: node environment: environment parentMethod: method).
	^ node definition