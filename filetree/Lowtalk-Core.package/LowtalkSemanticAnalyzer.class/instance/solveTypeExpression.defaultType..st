as yet unclassified
solveTypeExpression: typeExpression defaultType: aDefaultType
	^ typeExpression ifNotNil: [
		self evaluateTypeExpression: typeExpression
	] ifNil: [ 
		aDefaultType
	]
	
	